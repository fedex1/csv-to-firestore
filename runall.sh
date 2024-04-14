#!
PROJECT_ID="citytri-marketing"
SERVICE_ACCOUNT="$(gsutil kms serviceaccount -p ${PROJECT_ID})"

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member="serviceAccount:${SERVICE_ACCOUNT}" \
    --role='roles/pubsub.publisher'

# gsutil mb gs://config.citytri.com
gcloud config set functions/region us-central1
gcloud config set account fedex1@gmail.com

  # --trigger-bucket gs://citytri-marketing.appspot.com/config \
  # ERROR: (gcloud.functions.deploy) argument --trigger-bucket: At most one of --trigger-bucket | --trigger-http | --trigger-topic | --trigger-event --trigger-resource | --trigger-event-filters --trigger-event-filters-path-pattern --trigger-channel can be specified.
  # --trigger-bucket gs://config.citytri.com \
  # --trigger-event google.storage.object.finalize \
  # --trigger-event-filters="type=google.storage.object.finalize" \


gcloud functions deploy csv_to_firestore \
  --gen2 \
  --runtime python39 \
  --trigger-event-filters="type=google.cloud.storage.object.v1.finalized" \
  --trigger-event-filters="bucket=config.citytri.com" \
  --entry-point csv_to_firestore_trigger \
  --source ./python/ \
  --memory=1024MB \
  --set-env-vars=UPLOAD_HISTORY=FALSE,EXCLUDE_DOCUMENT_ID_VALUE=FALSE \
  --timeout=540 \
  --trigger-location=us

