mutable struct Nodehash
	num_rows::Int
	num_buckets::Int
	hash_a::Array{Int64,1}
	hash_b::Array{Int64,1}
	count::Array{Int64,2}
end

function Nodehash(r::Int, b::Int)
	Nodehash(r, b, rand(1:b, r), rand(0:b, r), zeros(Int, r, b))
end

function hash(node::Nodehash, a::Int, i::Int)
	resid = 1 + (a * node.hash_a[i] + node.hash_b[i]) % node.num_buckets
	return resid + (resid < 1 ? node.num_buckets : 0)
end

function insert(node::Nodehash, a::Int, weight::Int)
	for i in 1:node.num_rows
		bucket = hash(node, a, i)
		node.count[i, bucket] += weight
	end
end

function get_count(node::Nodehash, a::Int)
	bucket = hash(node, a, 1)
	min_count = edge.count[1, bucket]
	for i in 2:node.num_rows
		bucket = hash(node, a, i)
		min_count = min(min_count, edge.count[i, bucket])
	end
	return min_count
end

function clear(node::Nodehash)
	node.count = zeros(node.num_rows, node.num_buckets)
end

function lower(node::Nodehash, factor::Float64)
	node.count *= factor
end
