var totalCorrect = 0;
var count = 0;

// For Hotspots
var selectedHotspot = null;

function toggle_visibility(id)
{
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

function showNextQuestion()
{
	var nextCount = count + 1;
	document.getElementById('questionNumber' + count).style.display = 'none';
	if (document.getElementById('questionNumber' + nextCount))
	{
		document.getElementById('questionNumber' + nextCount).style.display = 'block';
	}
	else
	{
		document.getElementById('grade').style.display = 'block';
		if (totalCorrect == 1)
		{
			document.getElementById('grade').innerHTML = 'This completes the assessment. Your score is ' + totalCorrect + ' question correct out of ' + count + '.';
		}
		else
		{
			document.getElementById('grade').innerHTML = 'This completes the assessment. Your score is ' + totalCorrect + ' questions correct out of ' + count + '.';
		}
	}
}

function checkIfSingleTrue(radioObj, quizType)
{
	var radioLength = radioObj.answerChoiceRadio.length;
	var feedbackCorrect = document.getElementById('feedbackCorrect');
	var feedbackIncorrect = document.getElementById('feedbackIncorrect');
	var answer = null;
	
	for(var i=0; i < radioLength; i++)
	{
		if(radioObj.answerChoiceRadio[i].checked)
		{
			answer = radioObj.answerChoiceRadio[i].value.split(", ");
		}
	}
	
	// Show feedback if Knowledge Check or go to next question for Assessment
	if (quizType == 'Knowledge Check')
	{
		// is answer correct?
		if (answer)
		{
			if (answer[1])
			{
				feedbackCorrect.style.display = 'block';
				feedbackIncorrect.style.display = 'none';
			}
			else
			{
				feedbackIncorrect.style.display = 'block';
				feedbackCorrect.style.display = 'none';
			}
		}
		else
		{
			feedbackCorrect.style.display = 'none';
			feedbackIncorrect.style.display = 'none';
		}
	}
	else
	{
		// Check if answer is correct
		if (answer)
		{
			if (answer[1])
			{
				totalCorrect++;
			}
		}	
		count++;
		showNextQuestion();
	}
}

function checkIfMultipleTrue(checkObj, quizType)
{
	var feedbackCorrect = document.getElementById('feedbackCorrect');
	var feedbackIncorrect = document.getElementById('feedbackIncorrect');
	var checkLength = checkObj.answerChoiceCheckbox.length;
	var answer = null;
	var correctAnswers = [];
	var chosenAnswers = [];
	var correctChosenAnswers = [];
	var numberIncorrect = 0;
	var isCorrect = false;

	for(var i=0; i < checkLength; i++)
	{
		answer = checkObj.answerChoiceCheckbox[i].value.split(", ");
		if (answer[1] != "")
		{
			correctAnswers.push(answer[1]);
		}
		if (checkObj.answerChoiceCheckbox[i].checked)
		{
			chosenAnswers.push(answer[0]);
			if (answer[1] != "")
			{
				correctChosenAnswers.push(answer[1]);
			}
		}
	}

	// Show feedback if Knowledge Check or go to next question for Assessment
	if (quizType == 'Knowledge Check')
	{
		// Check if answer is correct
		if (chosenAnswers.length == correctChosenAnswers.length)
		{
			if(correctChosenAnswers.length == correctAnswers.length)
			{
				feedbackIncorrect.style.display = 'none';
				feedbackCorrect.style.display = 'block';	
			}
			else
			{
				feedbackIncorrect.style.display = 'block';
				feedbackCorrect.style.display = 'none';	
			}
		}
		else
		{
			feedbackIncorrect.style.display = 'block';
			feedbackCorrect.style.display = 'none';	
		}
	}
	else
	{
		// Check if answer is correct
		if (chosenAnswers.length == correctChosenAnswers.length)
		{
			if(correctChosenAnswers.length == correctAnswers.length)
			{
				totalCorrect++;	
			}
		}
		count++;
		showNextQuestion();
	}
}

function checkIfMatchingTrue(selectObj, selectBoxCount)
{
	var selected = null;
	var selectedAnswer = null;
	var correctAnswer = null;
	var numberIncorrect = 0;

	for (var i=1; i <= selectBoxCount; i++)
	{
		selected = (document.getElementById('matchChoice' + i).selectedIndex);
		selectedAnswer = document.getElementById('matchChoice' + i).options[selected].text;
		correctAnswer = document.getElementById('matchChoice' + i).name;

		if (selectedAnswer != correctAnswer)
		{
			numberIncorrect++;
		}
	}

	// WOULD HAVE SOMETHING LIKE THE FOLLOWING IF ABLE TO TEST AND WOULD NEED TO PASS IN quizType
	// Show feedback if Knowledge Check or go to next question for Assessment
	//if (quizType == 'Knowledge Check')
	if (numberIncorrect > 0)
	{
		feedbackIncorrect.style.display = 'block';
		feedbackCorrect.style.display = 'none';
		for (var j=1; j <= selectBoxCount; j++)
		{
			for (var k=0; k < selectBoxCount; k++)
			{
				if (document.getElementById('matchChoice' + j).options[k].text == document.getElementById('matchChoice' + j).name)
				{
					document.getElementById('matchChoice' + j).options[k].selected = true;
					document.getElementById('matchChoice' + j).options[k].style.color = "green";
				}
			}
		}
	}
	else
	{
		feedbackIncorrect.style.display = 'none';
		feedbackCorrect.style.display = 'block';
	}
	/*else
	{
		if (numberIncorrect == 0)
		{
			totalCorrect++;
		}
		count++;
		showNextQuestion();		
	}*/
}

// NOTE: This function does not deal with Knowledge Check because there were no Sortable Questions in Knowledge Check to test
function checkSortableCorrect (selectObj, quizType)
{
	var feedbackCorrect = document.getElementById('feedbackCorrect');
	var feedbackIncorrect = document.getElementById('feedbackIncorrect');
	var selectLength = selectObj.order.length;
	var isCorrect = true;

	for (var v = 0; v < selectLength; v++)
	{
		if (selectObj.order[v].id != selectObj.order[v].value)
		{
			isCorrect= false;
		}
	}

	// WOULD HAVE SOMETHING LIKE THE FOLLOWING IF ABLE TO TEST AND WOULD NEED TO PASS IN quizType
	// Show feedback if Knowledge Check or go to next question for Assessment
	/*if (quizType == 'Knowledge Check')
	{
		if (isCorrect)
		{
			feedbackCorrect.style.display = 'block';
			feedbackIncorrect.style.display = 'none';
			//noAnswerChosen.style.display = 'none'; //line not working completely
		}
		else
		{
			feedbackIncorrect.style.display = 'block';
			feedbackCorrect.style.display = 'none';
			//noAnswerChosen.style.display = 'none'; //line not working completely
		}
	}
	else
	{*/
	if (isCorrect)
	{
		totalCorrect++;
	}
	count++;
	showNextQuestion();
	//}
}

function validateInput(value, count)
{
	if (/[^1-9]/.test(value) || (value > count))
	{
		alert('Please enter a number between 1 and ' + count + '!');
	}
}

function shuffle(elems)
{
    allElems = (function(){
	var ret = [], l = elems.length;
	while (l--) { ret[ret.length] = elems[l]; }
	return ret;
    })();
 
    var shuffled = (function(){
        var l = allElems.length, ret = [];
        while (l--) {
            var random = Math.floor(Math.random() * allElems.length),
                randEl = allElems[random].cloneNode(true);
            allElems.splice(random, 1);
            ret[ret.length] = randEl;
        }
        return ret; 
    })(), l = elems.length;
 
    while (l--) {
        elems[l].parentNode.insertBefore(shuffled[l], elems[l].nextSibling);
        elems[l].parentNode.removeChild(elems[l]);
    } 
}

function showSlide(currentSlide, direction)
{
	var nextSlide = parseFloat(currentSlide) + 1;
	var previousSlide = parseFloat(currentSlide) - 1;
	
	if (direction == 'next')
	{
		document.getElementById('slide' + currentSlide).style.display = 'none';
		if (document.getElementById('slide' + nextSlide))
		{
			document.getElementById('slide' + nextSlide).style.display = 'block';
		}
	}
	if (direction == 'previous')
	{
		document.getElementById('slide' + currentSlide).style.display = 'none';
		if (document.getElementById('slide' + previousSlide))
		{
			document.getElementById('slide' + previousSlide).style.display = 'block';
		}
	}
}

function initializeHotspots(countTotal)
{
	for (var j=1; j <= countTotal; j++)
	{
		initializeCoords(j);
	}
}

function initializeCoords(id)
{
	// left and right coordinates
	var xCoords = new Array();
	var minXCoord = null;
	var maxXCoord = null;
	// up and down coordinates
	var yCoords = new Array();
	var minYCoord = null;
	var maxYCoord = null;
	
	// coordinate percentages
	var originalWidth = document.getElementById('hotspotImage').naturalWidth; //width;
	var originalHeight = document.getElementById('hotspotImage').naturalHeight; //height;
	var minYCoordPercent = null;
	var maxYCoordPercent = null;
	var minXCoordPercent = null;
	var maxXCoordPercent = null;
	var areaHeight = null;
	var areaWidth = null;
	
	var coordsString =  null;
	coordsString = document.getElementById(id).getAttribute('coords');
	
	var coordsArray = new Array();
	coordsArray = coordsString.split(",");
	
	for (var i=0; i < coordsArray.length; i=i+2)
	{
		xCoords.push(coordsArray[i]);
		yCoords.push(coordsArray[i + 1]);
	}

	minXCoord = Math.min.apply(Math, xCoords);
	maxXCoord = Math.max.apply(Math, xCoords);
	
	minYCoord = Math.min.apply(Math, yCoords);
	maxYCoord = Math.max.apply(Math, yCoords);
	
	minYCoordPercent = (minYCoord * 100)/originalHeight;
	maxYCoordPercent = (maxYCoord * 100)/originalHeight;
	minXCoordPercent = (minXCoord * 100)/originalWidth;
	maxXCoordPercent = (maxXCoord * 100)/originalWidth;
	
	areaHeight = maxYCoordPercent - minYCoordPercent;
	areaWidth = maxXCoordPercent - minXCoordPercent;
	
	document.getElementById('div' + id).style.top = minYCoordPercent + '%';
	document.getElementById('div' + id).style.left = minXCoordPercent + '%';
	document.getElementById('div' + id).style.height = areaHeight + '%';
	document.getElementById('div' + id).style.width = areaWidth + '%';
	
	// set max height and width of hotspotContent
	document.getElementById('hotspotContent').style.maxHeight = originalWidth;
	document.getElementById('hotspotContent').style.maxWidth = originalHeight;
}

function highlightArea(id, countTotal)
{
	selectedHotspot = id;
	// unhilight all unselected hotspots
	unhighlightArea(countTotal);

	// highlight only hotspot cursor is over
	document.getElementById('div' + id).style.borderWidth = '2px';
	document.getElementById('div' + id).style.borderColor = '#6CB7E8';
}


function unhighlightArea(countTotal)
{
	for (var j=1; j <= countTotal; j++)
	{
		if (j != selectedHotspot)
		{
			document.getElementById('div' + j).style.borderWidth = '1px';
			document.getElementById('div' + j).style.borderColor = '#C7C7C7';
		}
	}
}

function checkHotspotCorrect(correctAnswer, countTotal)
{
	var correctId = correctAnswer.replace(/^(hotspot)0*/, '');
	var feedbackCorrect = document.getElementById('feedbackCorrect');
	var feedbackIncorrect = document.getElementById('feedbackIncorrect');
	var correctCoords = document.getElementById(correctId).getAttribute('coords');

	if (correctId == selectedHotspot)
	{
		feedbackIncorrect.style.display = 'none';
		feedbackCorrect.style.display = 'block';
	}
	else
	{
		if (selectedHotspot)
		{
			feedbackIncorrect.style.display = 'block';
			feedbackCorrect.style.display = 'none';
			
			// Changed the selected hotspot to be the correct hotspot for feedback
			selectedHotspot = correctId;
			unhighlightArea(countTotal);
			document.getElementById('div' + correctId).style.borderColor = '#30BF30';
			document.getElementById('div' + correctId).style.borderWidth = '2px';
		}
	}
}