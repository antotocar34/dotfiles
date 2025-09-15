ls:
  @echo "Project: king-antoine-carnec-dev"
  @gcloud compute instances list --project=king-antoine-carnec-dev
  @echo ""
  @echo "Project: king-antoine-test-sandbox"
  @gcloud compute instances list --project=king-antoine-test-sandbox

ssh: 
  @echo "unimplemented"
  gcloud compute ssh --zone $ZONE $MACHINE_NAME --tunnel-through-iap --project $PROJECT
