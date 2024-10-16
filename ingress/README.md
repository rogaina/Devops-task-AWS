# Setting Up Ingress Controller with AWS IAM Permissions

Follow the steps below to add the necessary IAM permissions for the Ingress Controller and install it in your EKS cluster.

1. **Add IAM Permissions for Ingress Controller**: We need to add a permission role for the Ingress Controller to the IAM role user. Use the following JSON configuration for the `ingresscontrollerrole`:
   ```json
   {
       "Version": "2012-10-17",
       "Statement": [
           {
               "Effect": "Allow",
               "Action": [
                   "elasticloadbalancing:CreateLoadBalancer",
                   "elasticloadbalancing:DeleteLoadBalancer",
                   "elasticloadbalancing:DescribeLoadBalancers",
                   "elasticloadbalancing:RegisterTargets",
                   "elasticloadbalancing:DeregisterTargets",
                   "elasticloadbalancing:ModifyLoadBalancerAttributes",
                   "elasticloadbalancing:DescribeTargetGroups",
                   "elasticloadbalancing:DescribeTargetHealth",
                   "ec2:DescribeInstances",
                   "ec2:DescribeSecurityGroups",
                   "ec2:CreateSecurityGroup",
                   "ec2:AuthorizeSecurityGroupIngress",
                   "ec2:AuthorizeSecurityGroupEgress",
                   "ec2:DeleteSecurityGroup",
                   "ec2:DescribeSubnets"
               ],
               "Resource": "*"
           }
       ]
   }
   ```
  

2. **Create the Ingress Namespace**: Run the following command to create the ingress-nginx namespace:
   ```bash
   kubectl create ns ingress-nginx
   ```

3. **Install Ingress NGINX**: Install the Ingress NGINX controller using Helm:
   ```bash
   helm install ingress-nginx ingress-nginx-3.1.0.tgz -n ingress-nginx
   ```

4. **Edit the Ingress NGINX Controller Deployment**: Modify the deployment for the Ingress NGINX controller:
   ```bash
   kubectl edit deployment ingress-ingress-nginx-controller -n ingress-nginx
   ```

5. **Open TCP Port for Grafana**: To allow access to Grafana, add the following annotation to the load balancer service of the Ingress Controller:
   ```bash
   helm upgrade --install ingress ingress-nginx-v1.3.1.tgz -n ingress-nginx --set tcp.3000=monitoring/prometheus-stack-grafana:80 --set tcp.9090=monitoring/kube-prometheus-stack-prometheus:9090 --set tcp.8080=prod/cache-service-svc:8080 --set tcp.8081=prod/job-handler-svc:8081
   ```

6. **Edit the Ingress Controller Service**: Edit the service for the Ingress Controller:
   ```bash
   kubectl edit svc ingress-ingress-nginx-controller -n ingress-nginx
   ```
   Then, add the following annotations to the service:
   ```yaml
   service.beta.kubernetes.io/aws-load-balancer-backend-protocol: tcp
   service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: "true"
   service.beta.kubernetes.io/aws-load-balancer-type: nlb
   ```
   This configuration will launch a Network Load Balancer and allow access to Grafana,prometheus,cache-service and job-handler service.