/**
* jspsych-space-novel-stim
* Wouter Kool
*
* plugin for displaying a practice trial of the novel 2-step task in Kool, Cushman, & Gershman (2016)
*
**/

(function($) {
	jsPsych["space-novel-alien-stim"] = (function() {

		var plugin = {};
		
		var score = 0;
		
		var displayColor = '#0738db';
		var borderColor = '#197bff';
		var textColor = '#b8fff6';
		
		plugin.create = function(params) {

			params = jsPsych.pluginAPI.enforceArray(params, ['stimuli', 'choices']);
			
			var trials = new Array(params.nrtrials);
			
			for (var i = 0; i < trials.length; i++) {
				
				trials[i] = {};
				trials[i].choices = params.choices || [];
				trials[i].rews = params.rews;
								
				// timing parameters
				trials[i].feedback_time = params.feedback_time || 500;
				trials[i].ITI = params.ITI || 500;
				trials[i].points_time = params.points_time || 1500;
				trials[i].state_name = params.state_name || 'green';
				trials[i].state_name = params.state_name || 'green';
				
			}
			return trials;
			
		};
		
		plugin.trial = function(display_element, trial) {
			
			// if any trial variables are functions
			// this evaluates the function and replaces
			// it with the output of the function
			
			trial = jsPsych.pluginAPI.evaluateFunctionParameters(trial);
						
			progress = jsPsych.progress();
			if (progress.current_trial_local == 0) {
				score = 0;
			}
			
			state_name = trial.state_name;
			if (state_name == 'green') {
				var state_color = [35, 63, 39];
			}
			if (state_name == 'yellow') {
				var state_color = [240, 187, 57];
			}
			
			// store responses
			var setTimeoutHandlers = [];
			
			var keyboardListener = new Object;	
			
			// function to end trial when it is time
			var end_trial = function() {
				
				kill_listeners();
				kill_timers();
				
				//jsPsych.data.write(trial_data);
				
				var handle_points = setTimeout(function() {
					// clear the display
					display_element.html('');
					$('.jspsych-display-element').css('background-image', '');
				
					// move on to the next trial
					var handle_ITI = setTimeout(function() {
						jsPsych.finishTrial();
					}, trial.ITI);
					setTimeoutHandlers.push(handle_ITI);
				}, trial.points_time);
				setTimeoutHandlers.push(handle_points);
				
			};

			// function to handle responses by the subject
			var after_response = function(info) {
				
				kill_listeners();
				kill_timers();
								
				points = trial.rews;					
				display_stimuli(2);
				var handle_feedback = setTimeout(function() {
					display_stimuli(3);
					end_trial();
				}, trial.feedback_time);
				setTimeoutHandlers.push(handle_feedback);
			}								
		
			
		var display_stimuli = function(stage){
				
			kill_timers();
			kill_listeners();
				
			//state_name = state_names[state];
			//state_color = state_colors[state];
				
				
			if (stage==1) { // choice stage
				display_element.html('');

				$('.jspsych-display-element').css('background-image', 'url("img/'+state_name+'_planet.png")');				

				display_element.append($('<div>', {
					id: 'jspsych-space-novel-top-stim',
				}));
										
				display_element.append($('<div>', {
					style: 'clear:both',
				}));
						
				
				display_element.append($('<div>', {
					style: 'background-image: url(img/'+state_name+'_stim.png)',
					id: 'jspsych-space-novel-bottom-stim-left',
				}));
					
			}
				
			if (stage==2) { // feedback
				$('#jspsych-space-novel-bottom-stim-left').addClass('jspsych-space-novel-bottom-stim-border');
				$('#jspsych-space-novel-bottom-stim-left').css('border-color', 'rgba('+state_color[0]+','+state_color[1]+','+state_color[2]+', 1)');
			}
				
			if (stage==3) { // reward
				if (points>0) {
					$('#jspsych-space-novel-top-stim').css('background-image', 'url(img/treasure_'+points+'.png)');
				}
				if (points<0) {
					$('#jspsych-space-novel-bottom-stim-left').css('background-image', 'url(img/'+state_name+'_stim_sad.png)');
					$('#jspsych-space-novel-top-stim').css('background-image', 'url(img/antimatter_'+(-1*points)+'.png)');
				}
				if (points==0) {
					$('#jspsych-space-novel-top-stim').css('background-image', 'url(img/noreward.png)');
				}
			}
				
		}
			
		var start_response_listener = function(){
			if(JSON.stringify(trial.choices) != JSON.stringify(["none"])) {
				var keyboardListener = jsPsych.pluginAPI.getKeyboardResponse({
					callback_function: after_response,
					valid_responses: trial.choices,
					rt_method: 'date',
					persist: false,
					allow_held_key: false
				});
			}
		}
			
		var kill_timers = function(){
			for (var i = 0; i < setTimeoutHandlers.length; i++) {
				clearTimeout(setTimeoutHandlers[i]);
			}
		}
			
		var kill_listeners = function(){
			// kill keyboard listeners
			if(typeof keyboardListener !== 'undefined'){
				jsPsych.pluginAPI.cancelKeyboardResponse(keyboardListener);
			}
		}
			
		var next_part = function(){
							
			kill_timers();
			kill_listeners();
				
			display_stimuli(1);
							
			start_response_listener();
		}							
		
		next_part();
	};		
	
	return plugin;
	
})();
})(jQuery);
