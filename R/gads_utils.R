# cache
cd <- cachem::cache_disk(rappdirs::user_cache_dir("rgoogleads_cache"))
gads_get_fields_cached <- memoise(gads_get_fields, cache = cd)

