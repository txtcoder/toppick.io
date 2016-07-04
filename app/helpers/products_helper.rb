module ProductsHelper
    def to_cdn(link)
        if link
            link.sub('//toppickimages.s3-us-west-2.amazonaws.com','//image.toppicks.tech')
        else
            ""
        end
    end
end
