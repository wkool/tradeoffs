var instructions_1a_text = function(){
	var instructions = ["<div align=center>Welcome to this HIT!<br><br>Please read all following instructions very carefully.<br><br>It takes some time, but otherwise you will not know what to do.</div>",
	"<div align=center>In this HIT, you will be taking a spaceship from earth<br> to look for space treasure on two different planets:<br><br><img style='margin:0px auto;display:block;height:200px' src='img/example_planets.png'/></div>", 
	"<div align=center>Each planet has two aliens on it and each alien has its own space treasure mine.<br><br><img style='margin:0px auto;display:block;height:100px' src='img/example_aliens.png'/><br>Once you arrive to each planet, you will ask one of the aliens for space treasure from its mine.</div>",
	"<div align=justify>These aliens are nice, so if an alien just brought treasure up from the mine, it will share it with you. Space treasure looks like this:<br><br><img style='margin:0px auto;display:block' src='img/treasure.png'/><br>Sometimes, the alien will not bring up any treasure and you'll see an empty circle:<br><br><img style='margin:0px auto;display:block' src='img/noreward.png'/></div>",
	"<div align=justify>If an alien has a good mine, it means it can easily dig up space treasure and it will be very likely to have some to share. It might not have treasure every time you ask, but it will most of the time.<br><br>Another alien might have a bad mine that is hard to dig through at the moment and won't have treasure to share most times you ask.<br><br>At the end of each trial, the space treasure that you earned will be converted to points.<br><Br>Each piece of space treasure will be worth one point.</div>",
	"<div align=justify>On each planet, you can choose the left alien by pressing the 'F' key and the right alien by pressing the 'J' key. You will then see whether you got treasure.<br><br>Try practicing this a few times. In the following practice phase, always pick the alien that is highlighted.</div>"];
	return instructions
};

var instructions_1b_text = function(){
	var instructions = ["<div align=center>You may have noticed that this alien's mine was good. It gave you space treasure most of the time.<br><br>The mines of other aliens might be less good. To see this, you are going to ask another alien for treasure a few times.</div>"];
	return instructions
};

var instructions_1c_text = function(){
	var instructions = ["<div align=justify>See, this alien was not in a very good part of the mine, and could share very little space treasure.<br><br>Every alien has treasure in its mine, but they can't share every time. Some will be more likely to share because it is easier to dig right now.<br><br>In the following practice phase, you can choose between two aliens and try to figure out which one has more treasure to share.<br><br>Each alien will sometimes come up on the right, and sometimes come up on the left.<br><br>Which side an alien appears on does not matter. For instance, left is not luckier than right.</div>"];
	return instructions
};

var instructions_1d_text = function(){	
	var instructions = ["<div align=justify>Good! You might have learned that this alien had treasure more often:<br><br><img style='margin:0px auto;display:block;height:100px' src='img/green_stim_2.png'/><br>Also, even if this alien had a better mine, you couldn't be sure if it had treasure all the time.<br><br>The treasure an alien can give will change during the game. Those with a good mine might get to a part of the mine that is hard to dig. Those with little to share might find easier treasure to dig.<br><br>Any changes in an alien's mine will happen slowly, so try to focus to get as much treasure as possible.</div>",
	"<div align=justify>While the chance an alien has treasure to share changes over time, it changes slowly. So an alien with a good treasure mine right now will stay good for a while.<br><br>To find the alien with the best mine at each point in time, you must concentrate.</div>",
	"<div align=justify>Now that you know how to pick aliens, you can learn how the play the whole game.<br><br>You will travel from earth to one of two planets, a green planet and a yellow planet:<br><br><img style='margin:0px auto;display:block;height:200px' src='img/example_planets.png'/></div>",
	"<div align=justify>On each trial, you will first choose which spaceship to take.<br><br><img style='margin:0px auto;display:block;height:100px' src='img/example_rockets.png'/><br>The spaceships can fly to either planet, but one will mostly fly to the green planet, and the other mostly to the yellow planet.<br><br>The planet a spaceship goes to most won't change during the game.<br><br>Pick the one that you think will take you to the alien with the best mine, but remember sometimes you'll go to the other planet!</div>",
	"<div align=justify>Lets's practice before doing the full game. Here are a few hints before you start: <br><br>Hint #1:<br>Remember which aliens have treasure. How good a mine is changes slowly, so an alien that has a lot of treasure to share now will be very likely to share with you in the near future.<br><br>Hint #2:<br>Remember, each alien has its own mine. Just because one alien has a bad mine, does not mean another has a good mine. Also, there are no funny patterns in how likely it is that an alien shares treasure with you, like every other time you ask, or depending on which spaceship you took. The aliens are not tricking you.<br><br>Hint #3:<br>The spaceship you choose is important because often the alien on one planet is better than the ones on another planet. You can find more treasure by finding the spaceship that takes you to the right planet.</div>",
	"<div align=justify>In the real experiment, we are only going to give you 2 seconds for each response (2 seconds for the spaceships, and 2 seconds for the aliens). At the beginning that won't seem like very much time and you may find the task difficult. Over time, as you learn to play, you will find that 2 seconds is enough time to make good decisions.<br><br>Our advice is to think carefully about your strategy, but also to trust your instincts. By concentrating you can increase the number of points you win by a lot. There is an element of chance, but a lot of room for skill as well.<br><br>Now, you will do 25 practice trials. These don't count, and have no time limit in order to help you learn.</div>"];
	return instructions
};

var instructions_2_text = function(){
	var instructions_2 = ["<div align=justify>Ok, you've finished all practice phases. In the real game, you will find new planets, new aliens and new mines, but the rules and the spaceships will be the same.<br><br>Let's review everything we've learned and then begin playing.<br><br>Remember, you want to find as much space treasure as you can by flying to planets and asking an alien to mine for you. The chance that an alien can share space treasure with you changes slowly over time, so you need to concentrate and be flexible to keep track of which spaceships and aliens are good right now.</div>",
	"<div align=justify>How much bonus money you make is based on how much space treasure you find. You will get a bonus payment of 1 cent for every point you earn. On average people win about $0.75, and some have won more than $1.00.<br><br>The game lasts for 125 trials and you will have two seconds for each choice, and that takes most people about 20 minutes. Good luck!</div>"];
	return instructions_2
}

function createMemberInNormalDistribution(mean,std_dev){
	return mean + (gaussRandom()*std_dev);
}
/*
* Returns random number in normal distribution centering on 0.
* ~95% of numbers returned should fall between -2 and 2
*/
function gaussRandom() {
	var u = 2*Math.random()-1;
	var v = 2*Math.random()-1;
	var r = u*u + v*v;
	/*if outside interval [0,1] start over*/
	if(r == 0 || r > 1) return gaussRandom();

	var c = Math.sqrt(-2*Math.log(r)/r);
	return u*c;

	/* todo: optimize this algorithm by caching (v*c) 
	* and returning next time gaussRandom() is called.
	* left out for simplicity */
}

function shuffle(o){
	for(var j, x, i = o.length; i; j = Math.floor(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
	return o;
}

var images = ['img/earth_planet.png',
'img/earth_stim_1.png',
'img/earth_stim_2.png',
'img/earth_stim_1_deact.png',
'img/earth_stim_2_deact.png',
'img/red_planet.png',
'img/red_stim_1.png',
'img/red_stim_1_sad.png',
'img/red_stim_1_deact.png',
'img/red_stim_2.png',
'img/red_stim_2_sad.png',
'img/red_stim_2_deact.png',
'img/purple_planet.png',
'img/purple_stim_1.png',
'img/purple_stim_1_sad.png',
'img/purple_stim_1_deact.png',
'img/purple_stim_2.png',
'img/purple_stim_2_sad.png',
'img/purple_stim_2_deact.png',
'img/green_planet.png',
'img/green_stim_1.png',
'img/green_stim_1_sad.png',
'img/green_stim_1_deact.png',
'img/green_stim_2.png',
'img/green_stim_2_sad.png',
'img/green_stim_2_deact.png',
'img/yellow_planet.png',
'img/yellow_stim_1.png',
'img/yellow_stim_1_sad.png',
'img/yellow_stim_1_deact.png',
'img/yellow_stim_2.png',
'img/yellow_stim_2_sad.png',
'img/yellow_stim_2_deact.png',
'img/treasure.png',
'img/noreward.png',
'img/example_rockets.png',
'img/example_aliens.png',
'img/example_planets.png',
];

function save_data(data,table_name){
	
for (i = 0; i < data.length; i++) {
	delete data[i].internal_chunk_id;
	delete data[i].trial_index_global;
	delete data[i].trial_type;
	}
		
	$.ajax({
		type:'post',
		cache: false,
		url: 'savedata.php', // change this to point to your php file.
		// opt_data is to add additional values to every row, like a subject ID
		// replace 'key' with the column name, and 'value' with the value.
		data: {
			table: table_name,
			json: JSON.stringify(data),
		},
		success: function(){
			console.log("hieperdepiep");
		}// write the result to javascript console
		//success: function(output) { console.log(output); } // write the result to javascript console
	});
}

function getQueryVariable(variable)
{
       var query = window.location.search.substring(1);
       var vars = query.split("&");
       for (var i=0;i<vars.length;i++) {
               var pair = vars[i].split("=");
               if(pair[0] == variable){return pair[1];}
       }
       return(false);
}
