Background
================
The ACME company wants the candidate to deploy their new super duper web application to AWS
or Azure. The company employs some pretty interesting developers and they can on occasion play
russian roulette on the instances. The candidate should keep this in mind (Don't ask why they have
access to production).
____

## Dependencies
The application has no dependencies.

## Assumptions
I've assumed that the application currently runs on a Kubernetes cluster.
The app runs with 2 replica pods using a deployment manifest.
Connectivity is established by a LoadBalancer Service, which creates a Load Balancer in the corresponding cloud setup.

Problem 1
================
Use any tool to be able to create a repeatable and predictable product deployment.
Restrictions
There are no restrictions and the candidate should see this as an opportunity to showcase their
ability to perform repeatable and predictable deployments to one of the cloud providers listed
(AWS/Azure).
Verification
The deployment can be verified by issuing a web request to http://{ip}:8080/success

## Solution
This has been achieved using a combination of Docker, Jenkins and Helm. A pipeline has been configured to trigger on the push event in the Git repository.
The pipeline eventually packages the latest code into an artifact called webapp.war, builds a docker image with the corresponding build number as tag.
The docker image is then pushed into Docker Hub.
Then switch context to the K8S agent which comes with helm installed.
Finally use the helm upgrade command to upgrade the deployment with the current artifact tag.


Problem 2
================
The application has been updated and the candidate is required to deploy a new version of the
application and take into consideration that downtime should be minimized.

## Solution
Kubernetes supports rolling updates using which zero downtime can be achieved.
I have set the number of replicas of the app to 2.
As shown in the previous solution, helm updates the deployement manifest with the latest artifact tag and instructs Kubernetes to apply the same.
When a rolling update is performed, the latest artifact is pushed as a fresh pod and the pods holding the previous artifact are gradually destroyed, resulting in zero downtime.
