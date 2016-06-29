module ProductsHelper
    def to_cdn(link)
        link.sub('//toppickimages.s3-us-west-2.amazonaws.com','//image.toppicks.tech')
    end
end
