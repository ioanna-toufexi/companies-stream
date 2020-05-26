# SIC codes for Accommodation and food service activities, as found in https://www.siccode.co.uk/section/i

hospitality_all = list(`55100`="Hotels and similar accommodation",
                   `55201`= "Holiday centres and villages",
                   `55202`= "Youth hostels",
                   `55209`= "Other holiday and other short stay accommodation (not including holiday centres and villages or youth hostels) n.e.c.",
                   `55300`= "Camping grounds, recreational vehicle parks and trailer parks",
                   `55900`= "Other accommodation",
                   `56101`= "Licensed restaurants",
                   `56102`= "Unlicensed restaurants and cafes",
                   `56103`= "Take away food shops and mobile food stands",
                   `56210`= "Event catering activities",
                   `56290`= "Other food service activities",
                   `56301`= "Licensed clubs",
                   `56302`= "Public houses and bars")

most_affected = list(`55100`="Hotels and similar accommodation",
                   `55209`= "Other holiday and other short stay accommodation (not including holiday centres and villages or youth hostels) n.e.c.",
                   `55900`= "Other accommodation",
                   `56101`= "Licensed restaurants",
                   `56102`= "Unlicensed restaurants and cafes",
                   `56103`= "Take away food shops and mobile food stands",
                   `56210`= "Event catering activities",
                   `56301`= "Licensed clubs",
                   `56302`= "Public houses and bars")

least_affected_or_too_small  = list(
                   `55201`= "Holiday centres and villages",
                   `55202`= "Youth hostels",
                   `55300`= "Camping grounds, recreational vehicle parks and trailer parks",
                   `56290`= "Other food service activities")

test_sic = list(`56302`= "Public houses and bars")