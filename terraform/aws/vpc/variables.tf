variable "region" {
  default     = "us-west-2"
  description = "AWS region"
}

variable "name" {
    default = "envmgr-demo-vpc"
    description = "vpc name"
}

variable "email" {
  description = "Email tag to be added while creating the resource"
}


[{"type": "WorkloadSnapshotUnschedule", "reason": "unassigned", "status": "NotSet", "lastUpdated": "2023-08-22T06:06:50.563559915Z"}, {"type": "WorkloadSnapshotSchedule", "reason": "assigned", "status": "Success", "lastUpdated": "2023-08-24T02:53:09.17559719Z"}, {"type": "WorkloadSnapshotClusterDeployed", "reason": "deployed", "status": "Success", "lastUpdated": "2023-08-24T02:53:10.120340219Z"}, {"type": "WorkloadSnapshotClusterReady", "reason": "ready", "status": "Success", "lastUpdated": "2023-08-24T02:53:11.379657608Z"}]
[{"type": "WorkloadSnapshotUnschedule", "reason": "unassigned", "status": "NotSet", "lastUpdated": "2023-08-22T06:06:50.581592151Z"}, {"type": "WorkloadSnapshotSchedule", "reason": "assigned", "status": "Success", "lastUpdated": "2023-08-23T23:49:44.000325687Z"}, {"type": "WorkloadSnapshotClusterDeployed", "reason": "deployed", "status": "Success", "lastUpdated": "2023-08-23T23:49:49.902511647Z"}, {"type": "WorkloadSnapshotClusterReady", "reason": "ready", "status": "Success", "lastUpdated": "2023-08-23T23:49:51.149283921Z"}]

[{"type": "WorkloadSnapshotUnschedule", "reason": "unassigned", "status": "NotSet", "lastUpdated": "2023-08-22T06:06:50.54177204Z"}, {"type": "WorkloadSnapshotSchedule", "reason": "assigned", "status": "Success", "lastUpdated": "2023-08-23T22:34:32.497714716Z"}, {"type": "WorkloadSnapshotClusterDeployed", "reason": "deployed", "status": "Success", "lastUpdated": "2023-08-23T22:34:38.269419974Z"}, {"type": "WorkloadSnapshotClusterReady", "reason": "ready", "status": "Success", "lastUpdated": "2023-08-23T22:34:42.499255401Z"}]

update config_namespaces set conditions='[{"type": "WorkloadSnapshotUnschedule", "reason": "unassigned", "status": "NotSet", "lastUpdated": "2023-08-22T06:06:50.552204055Z"}, {"type": "WorkloadSna
pshotSchedule", "reason": "assigned", "status": "Success", "lastUpdated": "2023-08-23T23:56:00.197118538Z"}, {"type": "WorkloadSnapshotClusterDeployed", "rea
son": "cluster sharedservices-tst-eks-01: unable to upgrade: cannot patch \"examples-limit-range\" with kind LimitRange:  \"\" is invalid: patch: Invalid val
ue: \"{\\\"apiVersion\\\":\\\"v1\\\",\\\"kind\\\":\\\"LimitRange\\\",\\\"metadata\\\":{\\\"annotations\\\":{\\\"meta.helm.sh/release-name\\\":\\\"namespace-k
3r184e-examples\\\",\\\"meta.helm.sh/release-namespace\\\":\\\"examples\\\",\\\"rep-drift-action\\\":\\\"deny\\\"},\\\"creationTimestamp\\\":\\\"2023-08-23T2
2:34:41Z\\\",\\\"labels\\\":{\\\"app.kubernetes.io/managed-by\\\":\\\"Helm\\\",\\\"k8smgmt.io/project\\\":\\\"nostromo-tst\\\",\\\"rep-cluster\\\":\\\"mx70ge
k\\\",\\\"rep-cluster-name\\\":\\\"sharedservices-tst-eks-01\\\",\\\"rep-drift-reconcillation\\\":\\\"enabled\\\",\\\"rep-organization\\\":\\\"dk638qk\\\",\\
\"rep-partner\\\":\\\"rx28oml\\\",\\\"rep-placement\\\":\\\"k65yyp0\\\",\\\"rep-project\\\":\\\"kno0x82\\\",\\\"rep-project-name\\\":\\\"nostromo-tst\\\",\\\
"rep-workload\\\":\\\"namespace-k3r184e-examples\\\",\\\"rep-workloadid\\\":\\\"kg1637k\\\"},\\\"managedFields\\\":[{\\\"manager\\\":\\\"cluster-scheduler\\\
",\\\"operation\\\":\\\"Update\\\",\\\"apiVersion\\\":\\\"v1\\\",\\\"time\\\":\\\"2023-08-23T22:34:41Z\\\",\\\"fieldsType\\\":\\\"FieldsV1\\\",\\\"fieldsV1\\
\":{\\\"f:metadata\\\":{\\\"f:annotations\\\":{\\\".\\\":{},\\\"f:meta.helm.sh/release-name\\\":{},\\\"f:meta.helm.sh/release-namespace\\\":{},\\\"f:rep-drif
t-action\\\":{}},\\\"f:labels\\\":{\\\".\\\":{},\\\"f:app.kubernetes.io/managed-by\\\":{},\\\"f:k8smgmt.io/project\\\":{},\\\"f:rep-cluster\\\":{},\\\"f:rep-
cluster-name\\\":{},\\\"f:rep-drift-reconcillation\\\":{},\\\"f:rep-organization\\\":{},\\\"f:rep-partner\\\":{},\\\"f:rep-placement\\\":{},\\\"f:rep-project
\\\":{},\\\"f:rep-project-name\\\":{},\\\"f:rep-workload\\\":{},\\\"f:rep-workloadid\\\":{}}},\\\"f:spec\\\":{\\\"f:limits\\\":{}}}}],\\\"name\\\":\\\"exampl
es-limit-range\\\",\\\"namespace\\\":\\\"examples\\\",\\\"resourceVersion\\\":\\\"188880903\\\",\\\"uid\\\":\\\"b0abea79-0346-48c9-8ae5-5d8cacee4001\\\"},\\\
"spec\\\":{\\\"limits\\\":[{\\\"max\\\":{\\\"cpu\\\":\\\"0.015\\\",\\\"memory\\\":\\\"0.05859375Gi\\\"},\\\"type\\\":\\\"Pod\\\"},{\\\"default\\\":{\\\"cpu\\
\":\\\"0.001\\\",\\\"memory\\\":\\\"6.1035156e-05Gi\\\"},\\\"type\\\":\\\"Container\\\"}]}}\": quantities must match the regular expression ''^([+-]?[0-9.]+)(
[eEinumkKMGTP]*[-+]?[0-9]*)$''", "status": "Failed", "lastUpdated": "2023-08-23T23:56:00.974559586Z"}, {"type": "WorkloadSnapshotClusterReady", "reason": "rea
dy", "status": "Success", "lastUpdated": "2023-08-23T22:34:43.55291315Z"}]'::jsonb where name='examples' and organization_id=2232;


[{"type": "WorkloadSnapshotUnschedule", "reason": "unassigned", "status": "NotSet", "lastUpdated": "2023-08-22T06:06:50.54524334Z"}, {"type": "WorkloadSnapshotSchedule", "reason": "assigned", "status": "Success", "lastUpdated": "2023-08-23T22:44:33.600103019Z"}, {"type": "WorkloadSnapshotClusterDeployed", "reason": "deployed", "status": "Success", "lastUpdated": "2023-08-23T22:44:37.605595744Z"}, {"type": "WorkloadSnapshotClusterReady", "reason": "ready", "status": "Success", "lastUpdated": "2023-08-23T22:44:40.926325946Z"}]

[{"type": "WorkloadSnapshotUnschedule", "reason": "unassigned", "status": "NotSet", "lastUpdated": "2023-08-22T06:06:50.550081332Z"}, {"type": "WorkloadSnapshotSchedule", "reason": "assigned", "status": "Success", "lastUpdated": "2023-08-23T22:34:32.515216738Z"}, {"type": "WorkloadSnapshotClusterDeployed", "reason": "deployed", "status": "Success", "lastUpdated": "2023-08-23T22:34:40.332019144Z"}, {"type": "WorkloadSnapshotClusterReady", "reason": "ready", "status": "Success", "lastUpdated": "2023-08-23T22:34:44.633507489Z"}]

[{"type": "WorkloadSnapshotUnschedule", "reason": "unassigned", "status": "NotSet", "lastUpdated": "2023-08-22T06:06:50.550044214Z"}, {"type": "WorkloadSnapshotSchedule", "reason": "assigned", "status": "Success", "lastUpdated": "2023-08-23T23:49:43.957878131Z"}, {"type": "WorkloadSnapshotClusterDeployed", "reason": "deployed", "status": "Success", "lastUpdated": "2023-08-23T23:49:51.923291754Z"}, {"type": "WorkloadSnapshotClusterReady", "reason": "ready", "status": "Success", "lastUpdated": "2023-08-23T23:49:54.220564275Z"}]

[{"type": "WorkloadSnapshotUnschedule", "reason": "unassigned", "status": "NotSet", "lastUpdated": "2023-08-22T05:59:10.667954986Z"}, {"type": "WorkloadSnapshotSchedule", "reason": "assigned", "status": "Success", "lastUpdated": "2023-08-23T23:49:43.968479868Z"}, {"type": "WorkloadSnapshotClusterDeployed", "reason": "deployed", "status": "Success", "lastUpdated": "2023-08-23T23:49:53.004485004Z"}, {"type": "WorkloadSnapshotClusterReady", "reason": "ready", "status": "Success", "lastUpdated": "2023-08-23T23:49:55.216805063Z"}]

[{"type": "WorkloadSnapshotUnschedule", "reason": "unassigned", "status": "NotSet", "lastUpdated": "2023-08-22T05:59:10.614570382Z"}, {"type": "WorkloadSnapshotSchedule", "reason": "assigned", "status": "Success", "lastUpdated": "2023-08-23T22:44:33.598784792Z"}, {"type": "WorkloadSnapshotClusterDeployed", "reason": "deployed", "status": "Success", "lastUpdated": "2023-08-23T22:44:39.6273188Z"}, {"type": "WorkloadSnapshotClusterReady", "reason": "ready", "status": "Success", "lastUpdated": "2023-08-23T22:44:40.87491516Z"}]

[{"type": "WorkloadSnapshotUnschedule", "reason": "unassigned", "status": "NotSet", "lastUpdated": "2023-08-22T05:59:10.612812176Z"}, {"type": "WorkloadSnapshotSchedule", "reason": "assigned", "status": "Success", "lastUpdated": "2023-08-23T23:49:43.953609908Z"}, {"type": "WorkloadSnapshotClusterDeployed", "reason": "deployed", "status": "Success", "lastUpdated": "2023-08-23T23:49:53.032238765Z"}, {"type": "WorkloadSnapshotClusterReady", "reason": "ready", "status": "Success", "lastUpdated": "2023-08-23T23:49:55.307512828Z"}]

[{"type": "WorkloadSnapshotUnschedule", "reason": "unassigned", "status": "NotSet", "lastUpdated": "2023-08-22T05:59:10.610425812Z"}, {"type": "WorkloadSnapshotSchedule", "reason": "assigned", "status": "Success", "lastUpdated": "2023-08-23T23:49:43.985832549Z"}, {"type": "WorkloadSnapshotClusterDeployed", "reason": "deployed", "status": "Success", "lastUpdated": "2023-08-23T23:49:50.00799314Z"}, {"type": "WorkloadSnapshotClusterReady", "reason": "ready", "status": "Success", "lastUpdated": "2023-08-23T23:49:55.215873232Z"}]

[{"type": "WorkloadSnapshotUnschedule", "reason": "unassigned", "status": "NotSet", "lastUpdated": "2023-08-22T05:59:10.61061881Z"}, {"type": "WorkloadSnapshotSchedule", "reason": "assigned", "status": "Success", "lastUpdated": "2023-08-23T23:49:43.952195391Z"}, {"type": "WorkloadSnapshotClusterDeployed", "reason": "deployed", "status": "Success", "lastUpdated": "2023-08-23T23:49:53.143207246Z"}, {"type": "WorkloadSnapshotClusterReady", "reason": "ready", "status": "Success", "lastUpdated": "2023-08-23T23:49:55.535086532Z"}]

[{"type": "WorkloadSnapshotUnschedule", "reason": "unassigned", "status": "NotSet", "lastUpdated": "2023-08-22T05:59:10.611220576Z"}, {"type": "WorkloadSnapshotSchedule", "reason": "assigned", "status": "Success", "lastUpdated": "2023-08-23T22:34:32.485236644Z"}, {"type": "WorkloadSnapshotClusterDeployed", "reason": "deployed", "status": "Success", "lastUpdated": "2023-08-23T22:34:38.2680505Z"}, {"type": "WorkloadSnapshotClusterReady", "reason": "ready", "status": "Success", "lastUpdated": "2023-08-23T22:34:43.528490646Z"}]

[{"type": "WorkloadSnapshotUnschedule", "reason": "unassigned", "status": "NotSet", "lastUpdated": "2023-08-22T05:59:10.614195719Z"}, {"type": "WorkloadSnapshotSchedule", "reason": "assigned", "status": "Success", "lastUpdated": "2023-08-23T23:49:43.953210326Z"}, {"type": "WorkloadSnapshotClusterDeployed", "reason": "deployed", "status": "Success", "lastUpdated": "2023-08-23T23:49:54.221515162Z"}, {"type": "WorkloadSnapshotClusterReady", "reason": "ready", "status": "Success", "lastUpdated": "2023-08-23T23:49:56.562420858Z"}]

[{"type": "WorkloadSnapshotUnschedule", "reason": "unassigned", "status": "NotSet", "lastUpdated": "2023-08-22T05:59:10.795505741Z"}, {"type": "WorkloadSnapshotSchedule", "reason": "assigned", "status": "Success", "lastUpdated": "2023-08-23T23:49:43.958916996Z"}, {"type": "WorkloadSnapshotClusterDeployed", "reason": "deployed", "status": "Success", "lastUpdated": "2023-08-23T23:49:49.923025564Z"}, {"type": "WorkloadSnapshotClusterReady", "reason": "ready", "status": "Success", "lastUpdated": "2023-08-23T23:49:54.222609011Z"}]

[{"type": "WorkloadSnapshotUnschedule", "reason": "unassigned", "status": "NotSet", "lastUpdated": "2023-08-22T05:59:10.612329731Z"}, {"type": "WorkloadSnapshotSchedule", "reason": "assigned", "status": "Success", "lastUpdated": "2023-08-23T22:34:32.476325055Z"}, {"type": "WorkloadSnapshotClusterDeployed", "reason": "deployed", "status": "Success", "lastUpdated": "2023-08-23T22:34:41.305813459Z"}, {"type": "WorkloadSnapshotClusterReady", "reason": "ready", "status": "Success", "lastUpdated": "2023-08-23T22:34:43.501934353Z"}]

[{"type": "WorkloadSnapshotUnschedule", "reason": "unassigned", "status": "NotSet", "lastUpdated": "2023-08-22T05:59:10.61076736Z"}, {"type": "WorkloadSnapshotSchedule", "reason": "assigned", "status": "Success", "lastUpdated": "2023-08-23T22:44:33.598659724Z"}, {"type": "WorkloadSnapshotClusterDeployed", "reason": "deployed", "status": "Success", "lastUpdated": "2023-08-23T22:44:37.527448124Z"}, {"type": "WorkloadSnapshotClusterReady", "reason": "ready", "status": "Success", "lastUpdated": "2023-08-23T22:44:39.734260143Z"}]

[{"type": "WorkloadSnapshotUnschedule", "reason": "unassigned", "status": "NotSet", "lastUpdated": "2023-08-22T06:06:50.552204055Z"}, {"type": "WorkloadSnapshotSchedule", "reason": "assigned", "status": "Success", "lastUpdated": "2023-08-24T03:36:32.80262193Z"}, {"type": "WorkloadSnapshotClusterDeployed", "reason": "deployed", "status": "Success", "lastUpdated": "2023-08-24T03:36:35.026882262Z"}, {"type": "WorkloadSnapshotClusterReady", "reason": "ready", "status": "Success", "lastUpdated": "2023-08-24T03:36:35.301513546Z"}]

[{"type": "WorkloadSnapshotUnschedule", "reason": "unassigned", "status": "NotSet", "lastUpdated": "2023-08-22T06:06:50.552739402Z"}, {"type": "WorkloadSnapshotSchedule", "reason": "assigned", "status": "Success", "lastUpdated": "2023-08-24T03:52:05.545343221Z"}, {"type": "WorkloadSnapshotClusterDeployed", "reason": "deployed", "status": "Success", "lastUpdated": "2023-08-24T03:52:10.972186929Z"}, {"type": "WorkloadSnapshotClusterReady", "reason": "ready", "status": "Success", "lastUpdated": "2023-08-24T03:52:11.296551938Z"}]