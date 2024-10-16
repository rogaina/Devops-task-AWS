
# DevOps Task




## Problem
we have an already existing infrastructure on AWS consisting of
the following components:

● EKS Cluster(s)

● RDS Database(s)

● Elasticache Instance(s)

● S3 Bucket(s)

● Elastic Load Balancer(s)

Some of the resources are shared between two or more products, in
varying degrees of usage for each product of said resource.
Assumed sizes and scales of resources are included at the end of this
document.

Currently the cost of each product is not well-calculated on its own
due to the nature of shared resources.
## Modifications and Optimizations


## EKS Cluster Architecture

The EKS cluster consists of six worker nodes, each with one of the following taints: `bug`, `apm`, `crash`, `survey`, `shared-services`, and `monitoring-ingress`.

### Namespaces and Resources

The EKS cluster includes the following namespaces and resources:

- **Namespace `prod`**: 
  - **Pods and Services**: `bug`, `apm`, `crash`, `survey`, `cache`, and `job-handler`.
  - **Pod Scheduling**:
    - Pods are scheduled on their corresponding nodes using **tolerations** and **node affinity** in the deployment YAML files or Helm charts.
    - For example:
      - The `bug` pod is scheduled on the node with the `bug` taint.
      - The `cache` and `job-handler` pods are scheduled on the node with the `shared-services` taint.
      - The same scheduling logic applies for the other pods (`apm`, `crash`, `survey`).

This description breaks down how the pods are scheduled and assigned to


- **Namespace `monitoring`**: 
  - Pods: `Prometheus` and `Grafana`.

- **AWS RDS MariaDB Instances**: 
  - Five RDS mariadb instances: `core`, `bugs`, `crashes`, `surveys`, `apm`.

- **AWS ElastiCache Redis Instances**: 
  - Four Redis ElastiCache instances: `core-cache`, `apm-cache`, `core-jobs`, `crashes-jobs`.

- **Additional AWS Resources**:
  - One **Network Load Balancer** (NLB).
  - One **S3** bucket.



