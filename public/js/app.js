document.getElementById('rules').addEventListener('click', (e) => {
	const displayStyle = document.getElementById('rules-list').style.display

	if (displayStyle === 'block') {
		document.getElementById('rules-list').style.display = 'none'	
	} else {
		document.getElementById('rules-list').style.display = 'block'	
	}
})