mutable struct Nodehash
	num_rows::Int
	num_buckets::Int
	hash_a::Int
	hash_b::Int
	count::Int
end

function Nodehash(r::Int, b::Int)
	Nodehash(r, b, rand(1:b, r), rand(0:b, r), zeros(r, b))
end

function hash(node::Nodehash, a::Int, i::Int)
	resid = (a * node.hash_a[i] + node.hash_b[i]) % node.num_buckets
	return resid + (resid < 0 ? node.num_buckets : else 0)
end

function insert(node::Nodehash, a::Int, weight::Int)
	for i in 1:node.num_rows
		bucket = hash(node, a, i)
		node.count[i, bucket] += weight
	end
end

function get_count(node::Nodehash, a::Int)
	bucket = hash(node, a, 0)
	min_count = count[0, bucket]
	for i in 1:node.num_rows
		bucket = hash(node, a, i)
		min_count = min(min_count, count[i, bucket])
	end
	return min_count
end

function clear(node::Nodehash)
	node.count = zeros(node.num_rows, node.num_buckets)
end

function lower(node::Nodehash, factor::Float64)
	node.count *= factor
end
