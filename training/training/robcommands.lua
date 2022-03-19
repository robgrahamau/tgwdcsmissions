

inputhash = 21001
hash = 21001
-- items go in here.


function tablespawn(tbl,_country,_cat)
	for k,v in pairs (tbl) do
		BASE:E({k,v})
		coalition.addGroup(_country,_cat,v)
	 end

end

function robinput()
	if unexpected_condition then error() end

end

