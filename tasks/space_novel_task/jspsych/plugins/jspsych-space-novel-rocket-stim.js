/**
* jspsych-space-novel-stim
* Wouter Kool
*
* plugin for displaying a practice trial of the novel 2-step task in Kool, Cushman, & Gershman (2016)
*
**/

(function($) {
	jsPsych["space-novel-rocket-stim"] = (function() {

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
				trials[i].practice = params.practice || 0;
				
				// timing parameters
				trials[i].feedback_time = params.feedback_time || 500;
				trials[i].planet_time = params.feedback_time || 2000;
				trials[i].ITI = params.ITI || 1000;
				//trials[i].score_time = params.score_time || 1500;
				//trials[i].level2_time = params.level2_time || 1000;
				//trials[i].totalscore_time = params.totalscore_time || 2000;
				
			}
			return trials;
			
		};
		
		plugin.trial = function(display_element, trial) {
			
			// if any trial variables are functions
			// this evaluates the function and replaces
			// it with the output of the function
			
			trial = jsPsych.pluginAPI.evaluateFunctionParameters(trial);
						
			var part = 0;
			var state_names = ["earth","green","yellow"];
			
			// store responses
			var setTimeoutHandlers = [];
			
			var keyboardListener = new Object;	
			
			var state = 0;
			
			var state_colors = [
				[5, 157, 190],
				[35, 63, 39],
				[240, 187, 57]
			];
			
			var stimsperstate = [1,2];
			stimsperstate = [stimsperstate, [3, 4]];
			var state1 = Math.ceil(Math.random()*2);
			var stims = shuffle(stimsperstate[state1-1]);
			
			var response = new Array(2);
			for (var i = 0; i < 2; i++) {	
				response[i] = {rt: -1, key: -1};
			}
			
			// function to end trial when it is time
			var end_trial = function() {
				
				kill_listeners();
				kill_timers();
				
				var trial_data = {
					"state2": state2,
				};
				
				jsPsych.data.write(trial_data);
				
				var handle_totalscore = setTimeout(function() {
					// clear the display
					display_element.html('');
					$('.jspsych-display-element').css('background-image', '');
				
					// move on to the next trial
					var handle_ITI = setTimeout(function() {
						jsPsych.finishTrial();
					}, trial.ITI);
					setTimeoutHandlers.push(handle_ITI);
				}, trial.totalscore_time);
				setTimeoutHandlers.push(handle_totalscore);
				
			};

			// function to handle responses by the subject
			var after_response = function(info) {
				
				kill_listeners();
				kill_timers();
								
				// only record the first response
				if (response[part].key == -1){
					response[part] = info;
				}
				
				display_stimuli(2); //feedback
				
				if (String.fromCharCode(response[part].key)==trial.choices[0]) { // left response
					choice1 = stims[0];
				} else {
					choice1 = stims[1];						
				}
				if ((choice1 == 1) || (choice1 == 3)) {
					state2 = 1;
				} else {
					state2 = 2;
				}					
				state = state2;
				
				var handle_feedback = setTimeout(function() {
					part = part + 1;
					display_stimuli(1);
					var handle_planet = setTimeout(function(){
						end_trial();
					}, trial.planet_time);
					setTimeoutHandlers.push(handle_planet);
				}, trial.feedback_time);
				setTimeoutHandlers.push(handle_feedback);
							
			};
			
			var display_stimuli = function(stage){
				
				kill_timers();
				kill_listeners();
				
				state_name = state_names[state];
				state_color = state_colors[state];
				
				if (stage==1) { // choice stage
					display_element.html('');

					$('.jspsych-display-element').css('background-image', 'url("img/'+state_name+'_planet.png")');				
					
					if (state>0) {
						display_element.append($('<div>', {
							style: 'background-image: url(img/earth_stim_'+choice1+'_deact.png)',
							id: 'jspsych-space-novel-top-stim',
						}));
					} else {
						display_element.append($('<div>', {
							id: 'jspsych-space-novel-top-stim',
						}));
					}
										
					display_element.append($('<div>', {
						style: 'clear:both',
					}));
						
					if (state == 0) {
						display_element.append($('<div>', {
							style: 'background-image: url(img/'+state_name+'_stim_'+stims[0]+'.png)',
							id: 'jspsych-space-novel-bottom-stim-left',
						}));
						display_element.append($('<div>', {
							id: 'jspsych-space-novel-bottom-stim-middle',
						}));
						display_element.append($('<div>', {
							style: 'background-image: url(img/'+state_name+'_stim_'+stims[1]+'.png)',
							id: 'jspsych-space-novel-bottom-stim-right',
						}));
					}
					
				}
				
				if (stage==2) { // feedback
					if (state == 0) {
						if (String.fromCharCode(response[part].key)==trial.choices[0]) { // left response
							$('#jspsych-space-novel-bottom-stim-right').css('background-image', 'url(img/'+state_name+'_stim_'+stims[1]+'_deact.png)');
							$('#jspsych-space-novel-bottom-stim-left').addClass('jspsych-space-novel-bottom-stim-border');
							$('#jspsych-space-novel-bottom-stim-left').css('border-color', 'rgba('+state_color[0]+','+state_color[1]+','+state_color[2]+', 1)');
						} else {
							$('#jspsych-space-novel-bottom-stim-left').css('background-image', 'url(img/'+state_name+'_stim_'+stims[0]+'_deact.png)');
							$('#jspsych-space-novel-bottom-stim-right').css('border-color', 'rgba('+state_color[0]+','+state_color[1]+','+state_color[2]+', 1)');
							$('#jspsych-space-novel-bottom-stim-right').addClass('jspsych-space-novel-bottom-stim-border');
						}
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
				
				part = part + 1;
				
				kill_timers();
				kill_listeners();
				
				display_stimuli(1);
				
				start_response_listener();
				
			};			
			
			next_part();
			
			};
		
			return plugin;
		})();
	})(jQuery);
