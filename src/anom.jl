function counts_to_anom(tot, cur, cur_t):
    cur_mean = tot / cur_t
    sqerr = max(0, cur - cur_mean) ^ 2
    return sqerr / cur_mean + sqerr / (cur_mean * max(1, cur_t - 1))
end

function midas(df, num_rows, num_buckets):
    m = maximum(df.src)
    cur_count = Edgehash(num_rows, num_buckets, m)
    total_count = Edgehash(num_rows, num_buckets, m)
    anom_score = []

    timestamp_keys = keys(groupby(df, ["timestamp"]))
    for timeframe in timestamp_keys:
        cur_t = timeframe.timestamp
        curr_df = get(groupby(df, ["timestamp"]), (timestamp=cur_t,), nothing)
        for row in eachrow(cur_df)
            cur_src = row.src
            cur_dst = row.dst
            insert(cur_count, cur_src, cur_dst, 1)
            insert(total_count, cur_src, cur_dst, 1)
            cur_mean = get_count(total_count, cur_src, cur_dst) / cur_t
            sqerr = (get_count(cur_count, cur_src, cur_dst) - cur_mean) ^ 2
            cur_score = cur_t == 1 ? 0 : sqerr / cur_mean + sqerr / (cur_mean * (cur_t - 1))
            cur_score = isnan(cur_score) ? 0 : cur_score
            push!(anom_score, cur_score)
        end
    end
    clear(cur_count)

    return anom_score
end
