class PosterSerializer
  def self.serialize_collection(posters)
    posters.each_with_object({}) do |poster, hash|
      hash["id: #{poster.id}"] = {
        type: "poster",
        attributes: {
          name: poster.name,
          description: poster.description,
          price: poster.price.to_f,
          year: poster.year,
          vintage: poster.vintage,
          img_url: poster.img_url
        }
      }
    end
  end
end

