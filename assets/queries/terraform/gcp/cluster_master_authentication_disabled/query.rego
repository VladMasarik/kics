package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[primary]
	not resource.master_auth

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, primary),
		"searchKey": sprintf("google_container_cluster[%s]", [primary]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'master_auth' is defined",
		"keyActualValue": "Attribute 'master_auth' is undefined",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[primary]
	resource.master_auth
	not bothDefined(resource.master_auth)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, primary),
		"searchKey": sprintf("google_container_cluster[%s].master_auth", [primary]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'master_auth.username' is defined and Attribute 'master_auth.password' is defined",
		"keyActualValue": "Attribute 'master_auth.username' is undefined or Attribute 'master_auth.password' is undefined",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[primary]
	resource.master_auth
	bothDefined(resource.master_auth)
	not bothFilled(resource.master_auth)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, primary),
		"searchKey": sprintf("google_container_cluster[%s].master_auth", [primary]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'master_auth.username' should not be empty and Attribute 'master_auth.password' should not be empty",
		"keyActualValue": "Attribute 'master_auth.username' is empty or Attribute 'master_auth.password' is empty",
	}
}

bothDefined(master_auth) {
	master_auth.username
	master_auth.password
}

bothFilled(master_auth) {
	count(master_auth.username) > 0
	count(master_auth.password) > 0
}
