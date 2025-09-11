# Canary Deployments

Purpose: Safely roll out changes to a subset of users, monitor metrics, and rollback on anomalies.

Tools:
- Argo Rollouts, Flagger, or Kubernetes Deployment strategies

Runbook:
- Deploy canary -> monitor latency/error metrics for N minutes -> promote or rollback
