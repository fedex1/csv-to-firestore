#!

gcloud config set functions/region us-central1
gcloud config set account citytri-marketing
gcloud functions deploy csv_to_firestore \
  --gen2 \
  --runtime python39 \
  --trigger-bucket gs://citytri-marketing.appspot.com/config \
  --trigger-event google.storage.object.finalize \
  --entry-point csv_to_firestore_trigger \
  --source . \
  --memory=1024MB \
  --set-env-vars=UPLOAD_HISTORY=FALSE,EXCLUDE_DOCUMENT_ID_VALUE=FALSE \
  --timeout=540

