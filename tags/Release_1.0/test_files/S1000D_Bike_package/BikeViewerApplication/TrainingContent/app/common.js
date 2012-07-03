function toggle_visibility(id) {
        var e = document.getElementById(id);		
		if(e.style.display == 'block' | e.style == null)
		{
			e.style.display = 'none';
			return false;
		}
		else
		{
			e.style.display = 'block';
			return true;
		}
}

function navToContent(url) 
{
}
function activate_flash_hotspots(hs_id, hs_title, icn) 
{
    alert(icn + " \r\n" + hs_id + " \r\n" + hs_title);
}

function openWindow(theFileName) {

    alert(theFileName);

}

