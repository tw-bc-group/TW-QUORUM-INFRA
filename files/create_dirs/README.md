
### Check EFS filesystem is used

create pod and efs
```sh
kubectl apply -f files/create_dirs/specs/

```

delete pod and efs

```sh
kubectl delete -f files/create_dirs/specs/
```

After the objects are created, verify that pod is running:


```sh
>> kubectl get pods
```

Also you can verify that data is written onto EFS filesystem:

```sh
kubectl exec -ti app1 -- ls -al
kubectl exec -ti app1 -- ls -al quorum

kubectl -n test-namespace exec -ti quorum-node1-deployment-598bfc9999-dmcb6  -- ls -al $QHOME


-rw-r--r--    1 root     root           464 Aug 10 13:38 date.txt
drwxr-xr-x    2 root     root          6144 Aug 10 13:38 quorum-dir1
drwxr-xr-x    2 root     root          6144 Aug 10 13:38 quorum-dir2
drwxr-xr-x    2 root     root          6144 Aug 10 13:38 quorum-dir3
drwxr-xr-x    2 root     root          6144 Aug 10 13:38 quorum-dir4
drwxr-xr-x    2 root     root          6144 Aug 10 13:38 quorum-dir5
drwxr-xr-x    2 root     root          6144 Aug 10 13:38 quorum-dir6
drwxr-xr-x    2 root     root          6144 Aug 10 13:38 quorum-dir7
drwxr-xr-x    2 root     root          6144 Aug 10 13:38 quorum-log1
drwxr-xr-x    2 root     root          6144 Aug 10 13:38 quorum-log2
drwxr-xr-x    2 root     root          6144 Aug 10 13:38 quorum-log3
drwxr-xr-x    2 root     root          6144 Aug 10 13:38 quorum-log4
drwxr-xr-x    2 root     root          6144 Aug 10 13:38 quorum-log5
drwxr-xr-x    2 root     root          6144 Aug 10 13:38 quorum-log6
drwxr-xr-x    2 root     root          6144 Aug 10 13:38 quorum-log7
drwxr-xr-x    2 root     root          6144 Aug 10 13:38 quorum-tm-dir1
drwxr-xr-x    2 root     root          6144 Aug 10 13:38 quorum-tm-dir2
drwxr-xr-x    2 root     root          6144 Aug 10 13:38 quorum-tm-dir3
drwxr-xr-x    2 root     root          6144 Aug 10 13:38 quorum-tm-dir4
drwxr-xr-x    2 root     root          6144 Aug 10 13:38 quorum-tm-dir5
drwxr-xr-x    2 root     root          6144 Aug 10 13:38 quorum-tm-dir6
drwxr-xr-x    2 root     root          6144 Aug 10 13:38 quorum-tm-dir7
```
