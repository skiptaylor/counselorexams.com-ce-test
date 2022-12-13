
$(window).load(function() {


	var current_question = 1;

	

	function myFunction() {
		var element = document.getElementById(current_question);
		element.classList.remove("current");
		var element = document.getElementById("start");
		element.classList.add("current");
	}



	function nextQuestion() {
		var element = document.getElementById(current_question);
		element.classList.add("current");
		current_question += 1;
		var element = document.getElementById(current_question);
		element.classList.remove("current");
	}

});