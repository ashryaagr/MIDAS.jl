mutable struct Edgehash
	num_rows::Int
	num_buckets::Int
	m::Int
	hash_a::Array{Int64,1}
	hash_b::Array{Int64,1}
	count::Array{Int64,2}
end

function Edgehash(r::Int, b::Int, m::Int)
	Edgehash(r, b, m, rand(1:b, r), rand(0:b, r), zeros(Int, r, b))
end

function hash(edge::Edgehash, a::Int, b::Int, i::Int)
	resid = 1 + ((a + edge.m * b) * edge.hash_a[i] + edge.hash_b[i]) % edge.num_buckets
	return resid + (resid < 1 ? edge.num_buckets : 0)
end

function insert(edge::Edgehash, a::Int, b::Int, weight::Int)
	for i in 1:edge.num_rows
		bucket = hash(edge, a, b, i)
		edge.count[i, bucket] += weight
	end
end

function get_count(edge::Edgehash, a::Int, b::Int)
	bucket = hash(edge, a, b, 1)
	min_count = edge.count[1, bucket]
	for i in 2:edge.num_rows
		bucket = hash(edge, a, b, i)
		min_count = min(min_count, edge.count[i, bucket])
	end
	return min_count
end

function clear(edge::Edgehash)
	edge.count = zeros(edge.num_rows, edge.num_buckets)
end

function lower(edge::Edgehash, factor::Float64)
	edge.count *= factor
end
