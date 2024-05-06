image_gallery_rg=CorpsG6
image_gallery_name=g6imagegallery
image_offer=0001-com-ubuntu-server-focal
image_sku=20_04-lts-gen2
image_version=latest
image_name=ubuntu-20.04
image_publisher="canonical"
image_version=1.0.0
managed_image_resource_group_name=g6imagegallery
generation="V2"

az sig image-definition create \
  --resource-group ${image_gallery_rg} \
  --gallery-name ${image_gallery_name} \
  --gallery-image-definition ${image_name} \
  --publisher ${image_publisher} \
  --offer ${image_offer} \
  --sku ${image_sku} \
  --hyper-v-generation ${generation} \
  --os-type Linux