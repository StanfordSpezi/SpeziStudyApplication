from firebase_functions import scheduler_fn
from firebase_admin import initialize_app, firestore, auth, storage
from spezi_data_pipeline.data_access.firebase_fhir_data_access import FirebaseFHIRAccess
from spezi_data_pipeline.data_flattening.fhir_resources_flattener import flatten_fhir_resources, FHIRDataFrame
from spezi_data_pipeline.data_processing.data_processor import FHIRDataProcessor
from spezi_data_pipeline.data_processing.observation_processor import calculate_activity_index
from spezi_data_pipeline.data_exploration.data_explorer import DataExplorer, visualizer_factory, explore_total_records_number
from spezi_data_pipeline.data_export.data_exporter import DataExporter
from datetime import date, timedelta
import os

initialize_app()

@scheduler_fn.on_schedule(schedule="every 168 hours")
def data_test(event: scheduler_fn.ScheduledEvent) -> None:

    start_date = date.today()
    end_date = start_date - timedelta(days=7)
    start_date = start_date.strftime('%Y-%m-%d')
    end_date = end_date.strftime('%Y-%m-%d')


    loinc_codes = ["55423-8", "8867-4"]
    file_paths = [
        "/survey/AHALE8.json",
        "/survey/Berlin.json",
        "/survey/Exercise BenefitsBarriers.json",
        "/survey/PADWalkingImpairment.json",
        "/survey/PHQ-9Depression.json",
        "/survey/PeripheralArteryQuestionnaire(PAQ).json",
        "/survey/PhysicalActivityQuestionnaire.json"
    ]

    db = firestore.client()

    firebase_access = FirebaseFHIRAccess(db)
    firebase_access.connect()

    users_ref = db.collection("users")
    users = users_ref.stream() 

    for user in users:
        user_id = user.id
        uid = user.id
        user_ref = db.collection('users').document(uid).collection('studies')
        studies = user_ref.stream()
       
        for study in studies:
            study_id = study.id
            subcollections = ["HealthKit", "QuestionnaireResponse"]
            
            for subcollection_name in subcollections:
                subcollection_ref = user_ref.document(study_id).collection(subcollection_name)
                subcollection_docs = subcollection_ref.stream()
                
                if any(subcollection_docs):
                    if subcollection_name == "QuestionnaireResponse":
                        print("this is a questionare response")
                        fhir_observations = firebase_access.fetch_data_path(f"users/{uid}/{"studies"}/{study_id}/{subcollection_name}", "authored", start_date, end_date)
                        flattened_fhir_dataframe = flatten_fhir_resources(fhir_observations, file_paths)
                    if subcollection_name == "HealthKit":
                        print("this is a healthkit value")
                        fhir_observations = firebase_access.fetch_data_path(f"users/{uid}/{"studies"}/{study_id}/{subcollection_name}", loinc_codes, "effectivePeriod.start", start_date, end_date)
                        flattened_fhir_dataframe = flatten_fhir_resources(fhir_observations)
                    else:
                        print("DOES NOT EXIST")
                
                if flattened_fhir_dataframe is not None:
                
                    local_csv_file_path = f"{uid}-{study_id}-{subcollection_name}.csv"

                    flattened_fhir_dataframe.df.head().to_csv(local_csv_file_path, index=False)
                                
                    firebase_storage_path = f"users/{user_id}/{study_id}/{subcollection_name}/{user_id}-{study_id}-{subcollection_name}.csv"

                    ##upload to stroaage bucket 
                    bucket = storage.bucket()
                    blob = bucket.blob(firebase_storage_path)
                    blob.upload_from_filename(local_csv_file_path)
                    print("Uploaded")

                    os.remove(local_csv_file_path)