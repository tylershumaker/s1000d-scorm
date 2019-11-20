var totalCorrect = 0;
var count = 0;
var weightScore = 0;

// Create step IDs
function countLI(element) {
    var prevLICount = 0;
    for (i = 0; i < element.length; i++) {

        if (element[i].tagName.toLowerCase() == 'li') {
            prevLICount = prevLICount + 1;
        }
    }

    return prevLICount;
}
function getParentIndex(element, arr) {
    if (element.parent().index() !== 'undefinded' && element.get(0).tagName.toLowerCase() !== 'html' ) {
        if (element.parent().get(0).tagName.toLowerCase() == 'ol') {
            var prevParents = element.parent().parent().prevAll();
            prevLICount = countLI(prevParents);
            arr.push(prevLICount);

            return getParentIndex(element.parent(), arr);
        } else {
            return getParentIndex(element.parent(), arr);
        }
    } else {
        return arr;
    }
}

function createStepIds (stepID) {
    stepID = stepID.replace(".", "\\.");

    var output = $("#"+stepID).index(); // get index of the current list item
    if(output == -1){
        return "1";
    }
    else {

        var step = $('#'+stepID);
        var _arr = [];
        _arr = getParentIndex($("#"+stepID), _arr);
        _arr.reverse()
        _arr.shift();

        console.log($("#"+stepID).prevAll("li"));
        _arr.push($("#"+stepID).prevAll("li").length);
        _arr = _arr.map(function (val) {
            return ++val;
        });

        console.log(_arr.join("."));
        return (_arr.join("."))

    }
};

function getStepNumber(stepID) {
    var stepNumber = createStepIds(stepID);

    console.log("stepID : " + stepID);
    console.log("stepNumber : " + stepNumber);

    return stepNumber;
}

// For Hotspots
var selectedHotspot = null;

function initializeXAPI(){
    output.log("XAPI Configured");
    var stepId = $('ol#mp li:first').attr('id');
    if (stepId != undefined){
        recordStep(stepId, ADL.verbs.attempted);
    }

}

function show_hide_div(hide_id, show_id) {
    remove_highlight(hide_id)
    add_highlight(show_id)
}

function remove_highlight(id) {
    console.log("In Highlight");
    var e = document.getElementById(id);
    e.classList.remove("active");
    next = e.getElementsByTagName('a');
    next[0].classList.remove("active");
    next[0].classList.add("inactive")

    recordStep(id, ADL.verbs.completed);
}

function add_highlight(id) {
    var e = document.getElementById(id);
    e.classList.add("active");
    next = e.getElementsByTagName('a');
    next[0].classList.add("active");
    next[0].classList.remove("inactive");

    recordStep(id, ADL.verbs.attempted);

}

function toggle_visibility(id) {
    var e = document.getElementById(id);
    if (e.style.display == 'block' | e.style == null) {
        e.style.display = 'none';
        return false;
    } else {
        e.style.display = 'block';
        return true;
    }
}


function activate_flash_hotspots(hs_id, hs_title, icn) {
    alert(icn + " \r\n" + hs_id + " \r\n" + hs_title);
}


function openWindow(theFileName) {

    alert(theFileName);

}

function showNextQuestion() {
    var nextCount = count + 1;
    document.getElementById('questionNumber' + count).style.display = 'none';
    if (document.getElementById('questionNumber' + nextCount)) {
        document.getElementById('questionNumber' + nextCount).style.display = 'block';
    } else {
        document.getElementById('grade').style.display = 'block';
        var status = '';
        var minScore = getMinScore();

        var score = (weightScore / count) * 100;

        if (score >= minScore) {

            doSetValue("cmi.completion_status", "completed");
            doSetValue("cmi.success_status", "passed");
            status = "passed";
        } else {
            doSetValue("cmi.completion_status", "incomplete");
            doSetValue("cmi.success_status", "failed");
            status = "failed";
        }
        var scaledScore = weightScore / count;

        doSetValue("cmi.score.scaled", scaledScore.toString());
        doSetValue("cmi.score.raw", weightScore.toString());
        doSetValue("cmi.score.min", "0");
        doSetValue("cmi.score.max", count.toString());

        document.getElementById('grade').innerHTML = 'You have ' + status + ' the assessment. <br/>' +
            'You answered ' + totalCorrect + ' question(s) correct out of ' + count + ' for a score of ' + score.toFixed(2) + '%.<br/>' +
            'This assessment required a ' + minScore + '% or greater to be passed. ';
    }
}


function setInteractions(_id, _type, _response, _result, _description) {
    var num = parseInt(doGetValue("cmi.interactions._count"));

    current_dmc = document.getElementById("dmc").innerHTML

    doSetValue("cmi.interactions." + num + ".id", "URN:" + current_dmc + "_" + _id);
    doSetValue("cmi.interactions." + num + ".type", _type);

    // case "1.2" :
    //     scorm.set("cmi.interactions." + num + ".student_response", _response);
    //     var result = (_result) ? "correct":"wrong";
    //     scorm.set("cmi.interactions." + num + ".result", result);
    //     break;
    //2004

    var result = (_result) ? "correct" : "incorrect";
    doSetValue("cmi.interactions." + num + ".result", result);
    doSetValue("cmi.interactions." + num + ".learner_response", _response);
    doSetValue("cmi.interactions." + num + ".description", _description);

}

function checkIfSingleTrue(radioObj, quizType) {
    var radioLength = radioObj.answerChoiceRadio.length;
    var feedbackCorrect = document.getElementById('feedbackCorrect');
    var feedbackIncorrect = document.getElementById('feedbackIncorrect');
    var answer = null;

    for (var i = 0; i < radioLength; i++) {
        if (radioObj.answerChoiceRadio[i].checked) {
            answer = radioObj.answerChoiceRadio[i].value.split(", ");
        }
    }

    var countPlusOne = count + 1;
    var qCountStr = 'questionCount' + countPlusOne.toString();
    var description = document.getElementById(qCountStr).innerHTML;

    setInteractions(count.toString(), "choice", answer[0], answer[1], description)

    // Show feedback if Knowledge Check or go to next question for Assessment
    if (quizType == 'Knowledge Check') {
        // is answer correct?
        if (answer) {
            if (answer[1]) {
                feedbackCorrect.style.display = 'block';
                feedbackIncorrect.style.display = 'none';
            } else {
                feedbackIncorrect.style.display = 'block';
                feedbackCorrect.style.display = 'none';
            }
        } else {
            feedbackCorrect.style.display = 'none';
            feedbackIncorrect.style.display = 'none';
        }
    } else {
        // Check if answer is correct
        if (answer) {
            if (answer[1]) {
                weightScore = weightScore + parseInt(answer[1]);
                totalCorrect++;
            }
        }
        count++;
        showNextQuestion();
    }
}

function checkIfMultipleTrue(checkObj, quizType) {

    var feedbackCorrect = document.getElementById('feedbackCorrect');
    var feedbackIncorrect = document.getElementById('feedbackIncorrect');
    var checkLength = checkObj.answerChoiceCheckbox.length;
    var answer = null;
    var correctAnswers = [];
    var chosenAnswers = [];
    var correctChosenAnswers = [];
    var numberIncorrect = 0;
    var isCorrect = false;

    for (var i = 0; i < checkLength; i++) {
        answer = checkObj.answerChoiceCheckbox[i].value.split(", ");

        if (answer[1] != "") {
            correctAnswers.push(answer[1]);
        }
        if (checkObj.answerChoiceCheckbox[i].checked) {
            chosenAnswers.push(answer[0]);
            if (answer[1] != "") {
                correctChosenAnswers.push(answer[1]);
            }
        }

    }

    var countPlusOne = count + 1;
    var qCountStr = 'questionCount' + countPlusOne.toString();
    var description = document.getElementById(qCountStr).innerHTML;

    setInteractions(count.toString(), "choice", chosenAnswers.length == correctChosenAnswers.length,
        chosenAnswers, description)

    // Show feedback if Knowledge Check or go to next question for Assessment
    if (quizType == 'Knowledge Check') {
        // Check if answer is correct
        if (chosenAnswers.length == correctChosenAnswers.length) {
            if (correctChosenAnswers.length == correctAnswers.length) {
                feedbackIncorrect.style.display = 'none';
                feedbackCorrect.style.display = 'block';
            } else {
                feedbackIncorrect.style.display = 'block';
                feedbackCorrect.style.display = 'none';
            }
        } else {
            feedbackIncorrect.style.display = 'block';
            feedbackCorrect.style.display = 'none';
        }
    } else {
        // Check if answer is correct
        if (chosenAnswers.length == correctChosenAnswers.length) {

            if (correctChosenAnswers.length == correctAnswers.length) {


                weightScore = weightScore + parseInt(correctChosenAnswers[0]);

                totalCorrect++;

            }
        }

        count++;
        showNextQuestion();
    }
}

function checkIfMatchingTrue(selectObj, selectBoxCount) {
    var selected = null;
    var selectedAnswer = null;
    var correctAnswer = null;
    var numberIncorrect = 0;

    for (var i = 1; i <= selectBoxCount; i++) {
        selected = (document.getElementById('matchChoice' + i).selectedIndex);
        selectedAnswer = document.getElementById('matchChoice' + i).options[selected].text;
        correctAnswer = document.getElementById('matchChoice' + i).name;

        if (selectedAnswer != correctAnswer) {
            numberIncorrect++;
        }
    }

    // WOULD HAVE SOMETHING LIKE THE FOLLOWING IF ABLE TO TEST AND WOULD NEED TO PASS IN quizType
    // Show feedback if Knowledge Check or go to next question for Assessment
    //if (quizType == 'Knowledge Check')
    if (numberIncorrect > 0) {
        feedbackIncorrect.style.display = 'block';
        feedbackCorrect.style.display = 'none';
        for (var j = 1; j <= selectBoxCount; j++) {
            for (var k = 0; k < selectBoxCount; k++) {
                if (document.getElementById('matchChoice' + j).options[k].text == document.getElementById('matchChoice' + j).name) {
                    document.getElementById('matchChoice' + j).options[k].selected = true;
                    document.getElementById('matchChoice' + j).options[k].style.color = "green";
                }
            }
        }
    } else {
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
function checkSortableCorrect(position) {
    var feedbackCorrect = document.getElementById('feedbackCorrect');
    var feedbackIncorrect = document.getElementById('feedbackIncorrect');
    var questionNumber = "#questionNumber" + position;
    var newOrdering = $(questionNumber).find(".sortable").sortable('toArray');
    var isCorrect = true;

    for (var v = 0; v < newOrdering.length; v++) {
        if (newOrdering[v] != (v + 1)) {
            isCorrect = false;
        }
    }

    var countPlusOne = count + 1;
    var qCountStr = 'questionCount' + countPlusOne.toString();
    var description = document.getElementById(qCountStr).innerHTML;

    setInteractions(count.toString(), "sequencing", isCorrect, newOrdering, description)

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
    if (isCorrect) {
        weightScore++;
        totalCorrect++;
    }
    count++;
    showNextQuestion();
    //}
}

function shuffle(elems) {
    allElems = (function () {
        var ret = [], l = elems.length;
        while (l--) {
            ret[ret.length] = elems[l];
        }
        return ret;
    })();

    var shuffled = (function () {
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

function showSlide(currentSlide, direction) {
    var nextSlide = parseFloat(currentSlide) + 1;
    var previousSlide = parseFloat(currentSlide) - 1;

    if (direction == 'next') {
        document.getElementById('slide' + currentSlide).style.display = 'none';
        if (document.getElementById('slide' + nextSlide)) {
            document.getElementById('slide' + nextSlide).style.display = 'block';
        }
    }
    if (direction == 'previous') {
        document.getElementById('slide' + currentSlide).style.display = 'none';
        if (document.getElementById('slide' + previousSlide)) {
            document.getElementById('slide' + previousSlide).style.display = 'block';
        }
    }
}

function highlightArea(id, coords, countTotal) {
    var coordsArray = new Array();
    coordsArray = coords.split(",");

    // left and right coordinates
    var xCoords = new Array();
    var minXCoord = null;
    var maxXCoord = null;
    // up and down coordinates
    var yCoords = new Array();
    var minYCoord = null;
    var maxYCoord = null;

    for (var i = 0; i < coordsArray.length; i = i + 2) {
        xCoords.push(coordsArray[i]);
        yCoords.push(coordsArray[i + 1]);
    }

    minXCoord = Math.min.apply(Math, xCoords);
    maxXCoord = Math.max.apply(Math, xCoords);

    minYCoord = Math.min.apply(Math, yCoords);
    maxYCoord = Math.max.apply(Math, yCoords);

    document.getElementById('div' + id).style.top = minYCoord;
    document.getElementById('div' + id).style.left = minXCoord;
    document.getElementById('div' + id).style.height = maxYCoord - minYCoord;//left = minXCoord;
    document.getElementById('div' + id).style.width = maxXCoord - minXCoord;//right = maxXCoord;

    // unhighlight all hotspots
    unhighlightArea(countTotal);

    // highlight only hotspot curser is over
    document.getElementById('div' + id).style.display = 'block';
}

function unhighlightArea(countTotal) {
    for (var j = 1; j <= countTotal; j++) {
        if (j != selectedHotspot) {
            document.getElementById('div' + j).style.display = 'none';
        }
    }
}

function selectArea(id, countTotal) {
    selectedHotspot = id;
    unhighlightArea(countTotal);
}

function checkHotspotCorrect(correctAnswer, countTotal) {
    var correctId = correctAnswer.replace(/^(hotspot)0*/, '');
    var feedbackCorrect = document.getElementById('feedbackCorrect');
    var feedbackIncorrect = document.getElementById('feedbackIncorrect');
    var correctCoords = document.getElementById('area' + correctId).getAttribute('coords');

    if (correctId == selectedHotspot) {
        feedbackIncorrect.style.display = 'none';
        feedbackCorrect.style.display = 'block';
    } else {
        if (selectedHotspot) {
            feedbackIncorrect.style.display = 'block';
            feedbackCorrect.style.display = 'none';
            document.getElementById('div' + selectedHotspot).style.display = 'none';

            // Changed the selected hotspot to be the correct hotspot for feedback
            selectedHotspot = correctId;
            highlightArea(correctId, correctCoords, countTotal);
            document.getElementById('div' + correctId).style.backgroundColor = '#30BF30';
        }
    }
}

function changeCallout(id, coords, countTotal) {
    for (var j = 1; j <= countTotal; j++) {
        document.getElementById('callout' + j).style.display = 'none';
    }

    var coordsArray = new Array();
    coordsArray = coords.split(",");

    // left and right coordinates
    var xCoords = new Array();
    var minXCoord = null;
    var maxXCoord = null;
    // up and down coordinates
    var yCoords = new Array();
    var minYCoord = null;
    var maxYCoord = null;

    for (var i = 0; i < coordsArray.length; i = i + 2) {
        xCoords.push(coordsArray[i]);
        yCoords.push(coordsArray[i + 1]);
    }

    minXCoord = Math.min.apply(Math, xCoords);
    maxXCoord = Math.max.apply(Math, xCoords);

    minYCoord = Math.min.apply(Math, yCoords);
    maxYCoord = Math.max.apply(Math, yCoords);

    document.getElementById('callout' + id).style.top = minYCoord;
    document.getElementById('callout' + id).style.left = minXCoord;
    document.getElementById('callout' + id).style.maxWidth = maxXCoord - minXCoord;

    document.getElementById('callout' + id).style.display = "block";
}

function doChoice(dmc) {

    doSetValue("adl.nav.request", "{target=ACT-DMC-" + dmc + "}choice");
    doSetValue("cmi.exit", "normal");
    var api = getAPIHandle();
    api.Terminate("");

}

function recordStep(id, verb) {
//Make xAPI call, viewed DMC
    var statement = getStepStatement(id, verb);
    console.log(statement);
    console.log(JSON.stringify(statement));

    try {
        ADL.XAPIWrapper.sendStatement(statement);
    } catch (err) {
        console.log(err.message);
    }
}

function getStepStatement(id, verb) {

    var learnerID = null;
    if (window.localStorage.learnerId == null) {
        learnerID = retrieveDataValue(scormVersionConfig.learnerIdElement);
    } else {
        learnerID = window.localStorage.learnerId;
    }

    var scormLaunchData = retrieveDataValue("cmi.launch_data");
    scormLaunchDataJSON = JSON.parse(scormLaunchData);

    var lmsHomePage = scormLaunchDataJSON.lmsHomePage;
    var activityId = scormLaunchDataJSON.activityId;
    var courseId = scormLaunchDataJSON.courseId;

    var stepByID = document.getElementById(id).childNodes;
    var stepContentHTML = stepByID[2].innerText;

    var stepNumber = getStepNumber(id);
    //var current_dmc = document.getElementById("dmc").innerHTML;
    var current_dmc = document.getElementById("meta-dmc").innerHTML;

    //Possibly change name to mbox:mailto:.... depending on learnerID
    return {
        actor: {
            objectType: "Agent",
            account: {
                homePage: lmsHomePage,
                name: learnerID,
            }
        },
        verb: verb,
        object: {
            id: "urn:s1000d:" + current_dmc,
            definition: {
                type: "https://w3id.org/xapi/artt/activity-types/s1000d/step"
            }
        },
        context: {
            contextActivities: {
                parent: [
                    {
                        id: activityId,
                        objectType: "Activity",
                        definition: {
                            type: "http://adlnet.gov/expapi/activities/lesson"
                        }
                    }
                ],
                grouping: [
                    {
                        id: "urn:s1000d:" + current_dmc,
                        objectType: "Activity",
                        definition: {
                            type: "http://adlnet.gov/expapi/activities/attempt"
                        }
                    },
                    {
                        id: courseId,
                        objectType: "Activity",
                        definition: {
                            type: "http://adlnet.gov/expapi/activities/course"
                        }
                    }
                ],
                category: [
                    {
                        id: "https://w3id.org/xapi/ARTT_Profile"
                    }
                ]
            },
            extensions: {
                "https://w3id.org/xapi/artt/extensions/s1000d/step": {
                    number: stepNumber,
                    id: id,
                    content: stepContentHTML
                }
            }
        },
            result: {
                response: ""
        }
    };
}