module ProductsHelper
    def to_cdn(link)
        link.sub('//toppickimages.s3-us-west-2.amazonaws.com','//d2h85wlswz56rg.cloudfront.net')
    end
end
