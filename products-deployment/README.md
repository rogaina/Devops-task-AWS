# Kubernetes Deployments and Services for Applications (APM, Bug, Survey, Crashes, Cache, Job-Handler)

The following steps will create the necessary Kubernetes deployments and services for the applications: APM, Bug, Survey, Crashes, Cache, and Job-Handler, connecting them to RDS, Redis, and S3. The deployments will be assigned to nodes with the `apm=true:NoSchedule` taint using node affinity and toleration.

## Deployment and Service YAML Example for **APM** (with Node Affinity and Toleration)

```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: apm-deployment
  namespace: prod
  labels:
    app: apm
spec:
  replicas: 2
  selector:
    matchLabels:
      app: apm
  template:
    metadata:
      labels:
        app: apm
    spec:
      containers:
        - name: apm
          image: your-apm-app-image:latest
          ports:
            - containerPort: 8080
          env:
            # Environment variables for RDS connection
            - name: DB_HOST
              value: "rds-apm-service.prod.svc.cluster.local" ## service of external rds endpoint
            - name: DB_PORT
              value: "3306"
            - name: DB_NAME
              value: "apm_db"
            - name: DB_USER
              valueFrom:
                secretKeyRef:
                  name: rds-apm-secret
                  key: username
            - name: DB_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: rds-apm-secret
                  key: password
            
            # Environment variables for Redis connection
            - name: REDIS_HOST
              value: "your-redis-endpoint.amazonaws.com"
            - name: REDIS_PORT
              value: "6379"
            - name: REDIS_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: redis-secret-apm
                  key: password
            
            # Environment variables for S3 connection
            - name: S3_BUCKET
              value: "s3-bucket-endpoint/apm"
            - name: AWS_ACCESS_KEY_ID
              valueFrom:
                secretKeyRef:
                  name: s3-secret
                  key: access_key
            - name: AWS_SECRET_ACCESS_KEY
              valueFrom:
                secretKeyRef:
                  name: s3-secret
                  key: secret_key
          resources:
            limits:
              memory: "512Mi"
              cpu: "500m"
            requests:
              memory: "256Mi"
              cpu: "250m"
      tolerations:
        - key: "apm"
          operator: "Equal"
          value: "true"
          effect: "NoSchedule"
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
              - matchExpressions:
                  - key: "apm"
                    operator: "In"
                    values:
                      - "true"
---
apiVersion: v1
kind: Service
metadata:
  name: apm-service
  namespace: prod
  labels:
    app: apm
spec:
  selector:
    app: apm
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
  type: ClusterIP
```

### Create the following Kubernetes secrets for storing sensitive data:
RDS secret
```bash
kubectl create secret generic rds-apm-secret -n prod \
  --from-literal=username=db-username \
  --from-literal=password=db-password
```
S3 Secret
```bash
kubectl create secret generic s3-secret -n prod \
  --from-literal=access_key=your-access-key \
  --from-literal=secret_key=your-secret-key
```
### Steps for Other Applications (Bug, Survey, Crashes, Cache, Job-Handler)

Repeat the above Deployment and Service YAML for each application (Bug, Survey, Crashes, Cache, Job-Handler), changing the following:

The previous configurations are dummy and general configuration and can change it based on each product requirement

```bash
kubectl apply -f apm-deployment.yml
kubectl apply -f apm-service.yml
kubectl apply -f bug-deployment.yml
kubectl apply -f bug-service.yml
kubectl apply -f survey-deployment.yml
kubectl apply -f survey-service.yml
kubectl apply -f crashes-deployment.yml
kubectl apply -f crashes-service.yml
kubectl apply -f cache-deployment.yml
kubectl apply -f cache-service.yml
kubectl apply -f job-handler-deployment.yml
kubectl apply -f job-handler-service.yml

```