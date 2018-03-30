#! /bin/bash

#
# Prometheus从节点上搜集了非常多的监控指标，但是Qingyuan Web UI上只展示少数几种
# 多余的监控指标只会浪费磁盘空间。Prometheus(v2.1.0)提供了接口来删除指定的监控
# 指标的数据记录。另外，对于占用磁盘空间的tombstone文件，Prometheus也提供了删除接口。
#
# 本脚本的功能是：
#    遍历所有的监控指标
#    如果需要保留，则跳过
#    否则删除该指标的数据记录
#    遍历结束后，清理tombstone
#
# TODO: 
# 	Prometheus地址通过参数传入
#	补全需要保留的监控指标
#

for i in {"cadvisor_version_info","container_cpu_cfs_periods_total","container_cpu_cfs_throttled_periods_total","container_cpu_cfs_throttled_seconds_total","container_cpu_system_seconds_total","container_cpu_usage_seconds_total","container_cpu_user_seconds_total","container_fs_inodes_free","container_fs_inodes_total","container_fs_io_current","container_fs_io_time_seconds_total","container_fs_io_time_weighted_seconds_total","container_fs_limit_bytes","container_fs_read_seconds_total","container_fs_reads_merged_total","container_fs_reads_total","container_fs_sector_reads_total","container_fs_sector_writes_total","container_fs_usage_bytes","container_fs_write_seconds_total","container_fs_writes_merged_total","container_fs_writes_total","container_last_seen","container_memory_cache","container_memory_failcnt","container_memory_failures_total","container_memory_rss","container_memory_swap","container_memory_usage_bytes","container_memory_working_set_bytes","container_network_receive_bytes_total","container_network_receive_errors_total","container_network_receive_packets_dropped_total","container_network_receive_packets_total","container_network_transmit_bytes_total","container_network_transmit_errors_total","container_network_transmit_packets_dropped_total","container_network_transmit_packets_total","container_scrape_error","container_spec_cpu_period","container_spec_cpu_quota","container_spec_cpu_shares","container_spec_memory_limit_bytes","container_spec_memory_swap_limit_bytes","container_start_time_seconds","container_tasks_state","etcd_debugging_mvcc_db_compaction_pause_duration_milliseconds_bucket","etcd_debugging_mvcc_db_compaction_pause_duration_milliseconds_count","etcd_debugging_mvcc_db_compaction_pause_duration_milliseconds_sum","etcd_debugging_mvcc_db_compaction_total_duration_milliseconds_bucket","etcd_debugging_mvcc_db_compaction_total_duration_milliseconds_count","etcd_debugging_mvcc_db_compaction_total_duration_milliseconds_sum","etcd_debugging_mvcc_db_total_size_in_bytes","etcd_debugging_mvcc_delete_total","etcd_debugging_mvcc_events_total","etcd_debugging_mvcc_index_compaction_pause_duration_milliseconds_bucket","etcd_debugging_mvcc_index_compaction_pause_duration_milliseconds_count","etcd_debugging_mvcc_index_compaction_pause_duration_milliseconds_sum","etcd_debugging_mvcc_keys_total","etcd_debugging_mvcc_pending_events_total","etcd_debugging_mvcc_put_total","etcd_debugging_mvcc_range_total","etcd_debugging_mvcc_slow_watcher_total","etcd_debugging_mvcc_txn_total","etcd_debugging_mvcc_watch_stream_total","etcd_debugging_mvcc_watcher_total","etcd_debugging_snap_save_marshalling_duration_seconds_bucket","etcd_debugging_snap_save_marshalling_duration_seconds_count","etcd_debugging_snap_save_marshalling_duration_seconds_sum","etcd_debugging_snap_save_total_duration_seconds_bucket","etcd_debugging_snap_save_total_duration_seconds_count","etcd_debugging_snap_save_total_duration_seconds_sum","etcd_debugging_store_expires_total","etcd_debugging_store_watch_requests_total","etcd_debugging_store_watchers","etcd_disk_backend_commit_duration_seconds_bucket","etcd_disk_backend_commit_duration_seconds_count","etcd_disk_backend_commit_duration_seconds_sum","etcd_disk_wal_fsync_duration_seconds_bucket","etcd_disk_wal_fsync_duration_seconds_count","etcd_disk_wal_fsync_duration_seconds_sum","etcd_helper_cache_entry_count","etcd_helper_cache_hit_count","etcd_helper_cache_miss_count","etcd_network_client_grpc_received_bytes_total","etcd_network_client_grpc_sent_bytes_total","etcd_request_cache_add_latencies_summary","etcd_request_cache_add_latencies_summary_count","etcd_request_cache_add_latencies_summary_sum","etcd_request_cache_get_latencies_summary","etcd_request_cache_get_latencies_summary_count","etcd_request_cache_get_latencies_summary_sum","etcd_server_has_leader","etcd_server_leader_changes_seen_total","etcd_server_proposals_applied_total","etcd_server_proposals_committed_total","etcd_server_proposals_failed_total","etcd_server_proposals_pending","get_token_count","get_token_fail_count","go_gc_duration_seconds","go_gc_duration_seconds_count","go_gc_duration_seconds_sum","go_goroutines","go_memstats_alloc_bytes","go_memstats_alloc_bytes_total","go_memstats_buck_hash_sys_bytes","go_memstats_frees_total","go_memstats_gc_sys_bytes","go_memstats_heap_alloc_bytes","go_memstats_heap_idle_bytes","go_memstats_heap_inuse_bytes","go_memstats_heap_objects","go_memstats_heap_released_bytes_total","go_memstats_heap_sys_bytes","go_memstats_last_gc_time_seconds","go_memstats_lookups_total","go_memstats_mallocs_total","go_memstats_mcache_inuse_bytes","go_memstats_mcache_sys_bytes","go_memstats_mspan_inuse_bytes","go_memstats_mspan_sys_bytes","go_memstats_next_gc_bytes","go_memstats_other_sys_bytes","go_memstats_stack_inuse_bytes","go_memstats_stack_sys_bytes","go_memstats_sys_bytes","http_request_duration_microseconds","http_request_duration_microseconds_count","http_request_duration_microseconds_sum","http_request_size_bytes","http_request_size_bytes_count","http_request_size_bytes_sum","http_requests_total","http_response_size_bytes","http_response_size_bytes_count","http_response_size_bytes_sum","kubelet_container_manager_latency_microseconds","kubelet_container_manager_latency_microseconds_count","kubelet_container_manager_latency_microseconds_sum","kubelet_containers_per_pod_count","kubelet_containers_per_pod_count_count","kubelet_containers_per_pod_count_sum","kubelet_docker_operations","kubelet_docker_operations_errors","kubelet_docker_operations_latency_microseconds","kubelet_docker_operations_latency_microseconds_count","kubelet_docker_operations_latency_microseconds_sum","kubelet_generate_pod_status_latency_microseconds","kubelet_generate_pod_status_latency_microseconds_count","kubelet_generate_pod_status_latency_microseconds_sum","kubelet_pleg_relist_interval_microseconds","kubelet_pleg_relist_interval_microseconds_count","kubelet_pleg_relist_interval_microseconds_sum","kubelet_pleg_relist_latency_microseconds","kubelet_pleg_relist_latency_microseconds_count","kubelet_pleg_relist_latency_microseconds_sum","kubelet_pod_start_latency_microseconds","kubelet_pod_start_latency_microseconds_count","kubelet_pod_start_latency_microseconds_sum","kubelet_pod_worker_latency_microseconds","kubelet_pod_worker_latency_microseconds_count","kubelet_pod_worker_latency_microseconds_sum","kubelet_pod_worker_start_latency_microseconds","kubelet_pod_worker_start_latency_microseconds_count","kubelet_pod_worker_start_latency_microseconds_sum","kubelet_running_container_count","kubelet_running_pod_count","kubelet_sync_pods_latency_microseconds","kubelet_sync_pods_latency_microseconds_count","kubelet_sync_pods_latency_microseconds_sum","machine_cpu_cores","machine_memory_bytes","openshift_build_info","process_cpu_seconds_total","process_max_fds","process_open_fds","process_resident_memory_bytes","process_start_time_seconds","process_virtual_memory_bytes","scrape_duration_seconds","scrape_samples_post_metric_relabeling","scrape_samples_scraped","ssh_tunnel_open_count","ssh_tunnel_open_fail_count","up"}
do
    # echo $i
    #if [  ${i:0:10} = "container_" ];then
    #    echo $i
    #fi

    # 保留需要监控的指标
    if [ "$i" = "container_cpu_usage_seconds_total" ];then
        continue
    fi

    # 删除该监控指标的数据记录
    curl -XPOST -g "172.30.233.80:9090/api/v1/admin/tsdb/delete_series?match[]=$i" \
        || echo "fail to remove record of $i"
done

# 清理tombstone（删除数据记录时会产生tombstone）
curl -XPOST 172.30.233.80:9090/api/v1/admin/tsdb/clean_tombstones \
    || echo "fail to clean tombstone"

echo "done!"
