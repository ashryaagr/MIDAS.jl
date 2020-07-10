macro load_darpa()
    quote
        data = DataFrame(CSV.File("./data/darpa_processed_data.csv"; header=[:src, :dst, :timestamp]))
        labels = DataFrame(CSV.File("./data/darpa_labels.txt", header=[:label]))
        data, labels.label
    end
end
