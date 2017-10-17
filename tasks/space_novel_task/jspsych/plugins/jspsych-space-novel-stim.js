/**
* jspsych-space-novel-stim
* Wouter Kool
*
* plugin for displaying a space-and-aliens version of the novel 2-step task in Kool, Cushman, & Gershman (2016)
*
**/

(function($) {
	jsPsych["space-novel-stim"] = (function() {

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
				trials[i].practice = params.practice || 0;
				trials[i].rews = params.rews;
				trials[i].subid = params.subid;
				
				//trials[i].fixed_time = params.fixed_time || false;
				
				// timing parameters
				trials[i].feedback_time = params.feedback_time || 500;
				trials[i].ITI = params.ITI || 1000;
				trials[i].timeout_time = params.timeout_time || 1500;
				trials[i].timing_response = params.timing_response || 2000; // if -1, then wait for response forever
				trials[i].score_time = params.score_time || 1500;
				trials[i].level2_time = params.level2_time || 1000;
				trials[i].totalscore_time = params.totalscore_time || 2000;
				
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
			
			var stimsperstate = [1,2];
			stimsperstate = [stimsperstate, [3, 4]];
			var state1 = Math.ceil(Math.random()*2);
			var stims = shuffle(stimsperstate[state1-1]);			

			var part = -1;
			var choice1 = -1;
			var state2 = -1;
						
			var points = 0;
			
			if (trial.practice == 0) {
				var state_names = ["earth","purple","red"];
				var state_colors = [
					[5, 157, 190],
					[115, 34, 130],
					[211, 0, 0]
				];
			} else {
				var state_names = ["earth","green","yellow"];
				var state_colors = [
					[5, 157, 190],
					[35, 63, 39],
					[240, 187, 57]
				];
				
			}
			
			// store responses
			var setTimeoutHandlers = [];
			
			var keyboardListener = new Object;	
			
			var response = new Array(2);
			for (var i = 0; i < 2; i++) {	
				response[i] = {rt: -1, key: -1};
			}

			var state = 0;
			
			var both_choices = [["F","J"],["space"]];
			var choices = new Array;
			
			// function to end trial when it is time
			var end_trial = function() {
				
				kill_listeners();
				kill_timers();
								
				// gather the data to store for the trial
				
				var trial_data = {
					"subid": trial.subid,
					"state1": state1,
					"stim_left": stims[0],
					"stim_right": stims[1],
					"rt_1": response[0].rt,
					"choice1": choice1,
					"rt_2": response[1].rt,
					"points": points,
					"state2": state2,
					"score": score,
					"practice": trial.practice,
					"rews1": trial.rews[0],
					"rews2": trial.rews[1],
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
				
				/*if (trial.timing_response>0) {
					var extra_time = trial.timing_response-response[part].rt;
				} else {
					var extra_time = 0;
				}*/
					
				var extra_time = 0;
				
				if (state == 0) {
					if (String.fromCharCode(response[part].key)==choices[0]) { // left response
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
						display_element.html('');
						next_part();		
					}, trial.feedback_time+extra_time);
					setTimeoutHandlers.push(handle_feedback);
					
				} else {
					
					points = trial.rews[state-1];
					score = score + points;

					
					display_stimuli(2);
					var handle_feedback = setTimeout(function() {
						display_stimuli(3);
						var handle_score = setTimeout(function() {
							display_stimuli(4);
							end_trial();
						}, trial.score_time);
						setTimeoutHandlers.push(handle_score);
					}, trial.feedback_time+extra_time);
					setTimeoutHandlers.push(handle_feedback);
				}			
				// show feedback	
							
			};
			
			var display_stimuli = function(stage){
				
				kill_timers();
				kill_listeners();
				
				state_name = state_names[state];
				state_color = state_colors[state];
				
				if (stage==-1) { // timeout	at first level
					if (state == 0) {
						$('#jspsych-space-novel-bottom-stim-left').html('<br><br>X');
						$('#jspsych-space-novel-bottom-stim-right').html('<br><br>X');
						$('#jspsych-space-novel-bottom-stim-left').css('background-image', 'url(img/'+state_name+'_stim_'+stims[0]+'_deact.png)');
						$('#jspsych-space-novel-bottom-stim-right').css('background-image', 'url(img/'+state_name+'_stim_'+stims[1]+'_deact.png)');
					} else {
						$('#jspsych-space-novel-bottom-stim-left').html('<br><br>X');
						$('#jspsych-space-novel-bottom-stim-left').css('background-image', 'url(img/'+state_name+'_stim_deact.png)');
					}
				}
				
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
					} else {
						display_element.append($('<div>', {
							style: 'background-image: url(img/'+state_name+'_stim.png)',
							id: 'jspsych-space-novel-bottom-stim-left',
						}));

					}
					
				}
				
				if (stage==2) { // feedback
					if (state == 0) {
						if (String.fromCharCode(response[part].key)==choices[0]) { // left response
							$('#jspsych-space-novel-bottom-stim-right').css('background-image', 'url(img/'+state_name+'_stim_'+stims[1]+'_deact.png)');
							$('#jspsych-space-novel-bottom-stim-left').addClass('jspsych-space-novel-bottom-stim-border');
							$('#jspsych-space-novel-bottom-stim-left').css('border-color', 'rgba('+state_color[0]+','+state_color[1]+','+state_color[2]+', 1)');
						} else {
							$('#jspsych-space-novel-bottom-stim-left').css('background-image', 'url(img/'+state_name+'_stim_'+stims[0]+'_deact.png)');
							$('#jspsych-space-novel-bottom-stim-right').css('border-color', 'rgba('+state_color[0]+','+state_color[1]+','+state_color[2]+', 1)');
							$('#jspsych-space-novel-bottom-stim-right').addClass('jspsych-space-novel-bottom-stim-border');
						}
					} else {
						$('#jspsych-space-novel-bottom-stim-left').addClass('jspsych-space-novel-bottom-stim-border');
						$('#jspsych-space-novel-bottom-stim-left').css('border-color', 'rgba('+state_color[0]+','+state_color[1]+','+state_color[2]+', 1)');
					}
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
				
				if (stage==4) { // 
					display_element.html('');
										
					if (points > 0) {
						picture = 'img/treasure_'+points+'.png';
					}
					if (points < 0) {
						picture = 'img/antimatter_'+Math.abs(points)+'.png';
					}
					if (points == 0) {
						picture = 'img/noreward.png';
					}
					
					$('.jspsych-display-element').css('background-image', 'url("img/earth_planet.png")');
					display_element.append($('<div>', {
						id: 'jspsych-space-novel-top-rewards',
					}));
					$('#jspsych-space-novel-top-rewards').append($('<div id="jspsych-space-novel-top-rewards-container"><img src="'+picture+'"></div>'))
					
					$('#jspsych-space-novel-top-rewards').append($('<div id="jspsych-space-novel-top-rewards-text"> = '+points+'</div>'))
					
					$('#jspsych-space-novel-top-rewards').append($('<div style="clear:both; height:20px"></div>'))
					$('#jspsych-space-novel-top-rewards').append($('<div id="jspsych-space-novel-top-rewards-text">total score: '+score+'</div>'))
				}
				
			}
			
			var start_response_listener = function(){
				
				if (part == 0) {
					choices = both_choices[0];
				} else {
					choices = both_choices[1];
				}
								
				if(JSON.stringify(choices) != JSON.stringify(["none"])) {
					var keyboardListener = jsPsych.pluginAPI.getKeyboardResponse({
						callback_function: after_response,
						valid_responses: choices,
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
					//jsPsych.pluginAPI.cancelKeyboardResponse(keyboardListener);
 +					jsPsych.pluginAPI.cancelAllKeyboardResponses();
				}
			}
			
			var next_part = function(){
				
				part = part + 1;
				
				kill_timers();
				kill_listeners();
				
				display_stimuli(1);
				
				start_response_listener();
				
				if (trial.timing_response>0) {	
					var handle_response = setTimeout(function() {
						kill_listeners();
						display_stimuli(-1);
						var handle_timeout = setTimeout(function() {
							end_trial();
						}, trial.timeout_time);
						setTimeoutHandlers.push(handle_timeout);
					}, trial.timing_response);
					setTimeoutHandlers.push(handle_response);
				}
			}			
			
			next_part();
			
		};
		
		return plugin;
	})();
})(jQuery);
