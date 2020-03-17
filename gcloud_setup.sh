echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
apt-get update && apt-get install google-cloud-sdk

export GOOGLE_APPLICATION_CREDENTIALS=silent-venture-269920-0ad84136605a.json
export PROJECT_ID=silent-venture-269920
gcloud auth login
gcloud config set project $PROJECT_ID
echo $PROJECT_ID
gcloud projects add-iam-policy-binding $PROJECT_ID \
   --member="user:wenqianh@gmail.com" \
   --role="roles/automl.editor"
gsutil mb -p $PROJECT_ID -c regional -l us-central1 gs://$PROJECT_ID-vcm/