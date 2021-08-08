PROJECT_ID=mussia8
APP_REGION=europe-west1

# define get-secret
# $(shell gcloud secrets versions access latest --secret=$(1) --project=$(PROJECT_ID))
# endef

create-file:
	export GOOGLE_CLIENT_SECRET=$(gcloud secrets versions access latest --secret=GOOGLE_CLIENT_SECRET)
	echo $GOOGLE_CLIENT_SECRET > .env.dev
	echo $(GOOGLE_CLIENT_SECRET) > .env.dev
	echo "Ars=sd" > .env.dev
	echo "append this text" >> .env.dev

use-sa:
	gcloud auth list

tp:
	gcloud auth list
	terraform plan

td:
	terraform destroy -auto-approve
ta:
	terraform apply -auto-approve
tv:
	terraform validate