function counts_to_anom(tot, cur, cur_t)
    cur_mean = tot / cur_t
    sqerr = max(0, cur - cur_mean) ^ 2
    return sqerr / cur_mean + sqerr / (cur_mean * max(1, cur_t - 1))
end

function midas(df, num_rows, num_buckets)
    m = maximum(df.src)
    cur_count = Edgehash(num_rows, num_buckets, m)
    total_count = Edgehash(num_rows, num_buckets, m)
    anom_score = []

    timestamp_keys = keys(groupby(df, ["timestamp"]))
    for timeframe in timestamp_keys
        cur_t = timeframe.timestamp
        cur_df = get(groupby(df, ["timestamp"]), (timestamp=cur_t,), nothing)
        for row in eachrow(cur_df)
            cur_src = row.src
            cur_dst = row.dst
            insert(cur_count, cur_src, cur_dst, 1)
            insert(total_count, cur_src, cur_dst, 1)
            cur_mean = get_count(total_count, cur_src, cur_dst) / cur_t
            sqerr = (get_count(cur_count, cur_src, cur_dst) - cur_mean) ^ 2
            cur_score = cur_t == 1 ? 0.0 : sqerr / cur_mean + sqerr / (cur_mean * (cur_t - 1))
            cur_score = isnan(cur_score) ? 0.0 : cur_score
            push!(anom_score, cur_score)
        end
        clear(cur_count)
    end

    return anom_score
end

function midasR(src, dst, times, num_rows, num_buckets, factor)
    m = maximum(src)
    num_entries = size(src)[1]
    cur_count = Edgehash(num_rows, num_buckets, m)
    total_count = Edgehash(num_rows, num_buckets, m)
    src_score = Nodehash(num_rows, num_buckets)
    dst_score = Nodehash(num_rows, num_buckets)
    src_total = Nodehash(num_rows, num_buckets)
    dst_total = Nodehash(num_rows, num_buckets)
    anom_score = zeros(num_entries)
    cur_t = 1

    for i in 1:num_entries
        if i == 1 | times[i] > cur_t
            lower(cur_count, factor)
            lower(src_score, factor)
            lower(dst_score, factor)
            cur_t = times[i]
        end

        cur_src = src[i]
        cur_dst = dst[i]
        insert(cur_count, cur_src, cur_dst, 1)
        insert(total_count, cur_src, cur_dst, 1)
        insert(src_score, cur_src, 1)
        insert(dst_score, cur_dst, 1)
        insert(src_total, cur_src, 1)
        insert(dst_total, cur_dst, 1)

        cur_score = counts_to_anom(
            get_count(total_count, cur_src, cur_dst),
            get_count(cur_count, cur_src, cur_dst),
            cur_t,
        )
        cur_score_src = counts_to_anom(
            get_count(src_total, cur_src), get_count(src_score, cur_src), cur_t
        )
        cur_score_dst = counts_to_anom(
            get_count(dst_total, cur_dst), get_count(dst_score, cur_dst), cur_t
        )
        combined_score = maximum([cur_score_src, cur_score_dst, cur_score])
        anom_score[i] = log(1 + combined_score)
    end
    return anom_score
end
