export GOOGLE_APPLICATION_CREDENTIALS=silent-venture-269920-0ad84136605a.json
export PROJECT_ID=silent-venture-269920
gcloud auth login
gcloud config set project $PROJECT_ID
echo $PROJECT_ID
gcloud projects add-iam-policy-binding $PROJECT_ID \
   --member="user:wenqianh@gmail.com" \
   --role="roles/automl.editor"
gsutil mb -p $PROJECT_ID -c regional -l us-central1 gs://$PROJECT_ID-vcm/