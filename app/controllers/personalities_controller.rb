require("json")
require("ibm_watson/personality_insights_v3")
require("ibm_watson/tone_analyzer_v3")

class PersonalitiesController < ApplicationController

  def show
    input_string = %{
Yeah, breakfast at Tiffany's and bottles of bubbles
Girls with tattoos who like getting in trouble
Lashes and diamonds, ATM machines
Buy myself all of my favorite things (Yeah)
Been through some bad shit
I should be a sad bitch
Who woulda thought it'd turn me to a savage?
Rather be tied up with calls and not strings
Write my own checks
Like I write what I sing, yeah (Yeah)
My wrist, stop watching, my neck is flossy
Make big deposits, my gloss is popping
You like my hair?
Gee, thanks, just bought it
I see it, I like it, I want it, I got it (Yeah)
I want it, I got it, I want it, I got it
I want it, I got it, I want it, I got it (Yeah)
You like my hair?
Gee, thanks, just bought it
I see it, I like it, I want it, I got it
(2 Chainz, yep)
My ideas are priceless
I know I'm the nicest
I knew you would like this
I must be psychic
I'm from the streets, baby
I'm nothing like them (Tru)
She's sweet in the day
but freaky when night come (Tell 'em)
It's mine, invested (Uh
I spend it on necklace (Uh)
I got the cash if I don't get credit (Uh)
And I'm well respected
So she feel protected
So scratch all the exes (Ex)
It's next like contestants (Woo)
It's blessings, no stressing, no flexing
Got one car parked right in the entrance
Got one car parked right at the exit
See, you didn't expect this
You think like a robot
I put bands in yo face like botox
I got it, I want it, I got it (Uh)
I want it, I got it (Uh),
I want it, I got it (Baby)
You like my hair?
Gee, thanks, just bought it (Oh yeah)
I see it, I like it, I want it, I got it (Yep)
Yeah, my receipts be looking like phone numbers
If it ain't money, then wrong number
Black card is my business card
The way it be setting the tone for me
I don't mean to brag
But I be like, put it in the bag, yeah
When you see them racks
They stacked up like my ass, yeah
Shoot, go from the store to the booth
Make it all back in one loop, gimme the loot
Never mind, I got a juice
Nothing but net when we shoot
Look at my neck
Look at my jet
Ain't got enough money to pay me respect
Ain't no budget when I'm on the set
If I like it, then that's what I get, yeah
I want it, I got it, I want it, I got it (Oh yeah)
I want it, I got it, I want it, I got it (Oh yeah, yeah)
You like my hair?
Gee, thanks, just bought it
I see it, I like it, I want it, I got it
(I see, yep)
} # end of input_string

    personality_apikey = ENV['PERSONALITY_APIKEY']
    puts "personality_apikey: #{personality_apikey}"

    personality_insights = IBMWatson::PersonalityInsightsV3.new(
      iam_apikey: personality_apikey,
      version: "2017-10-13"
    )

    profile_result = personality_insights.profile(
      content: input_string,
      content_type: "text/plain",
      accept: "application/json",
      raw_scores: true,
      consumption_preferences: true
    ).result

    # Save result to file TODO: remove before production deployment
    File.write("profile_result.json", JSON.pretty_generate(profile_result))
    @personality_results = {}
    profile_result["personality"].each do |personality_trait|
      @personality_results[personality_trait['name']] = (personality_trait['percentile'] * 100).round(1) #{personality_trait['percentile']}"
      # obj["children"].each do |child|
      #   puts "-- #{child['name']}"
      # end
    end

    tone_analyzer = IBMWatson::ToneAnalyzerV3.new(
      iam_apikey: ENV['TONE_APIKEY'],
      version: "2017-09-21"
    )

    tone_result = tone_analyzer.tone(
      tone_input: input_string,
      content_type: "text/plain"
    ).result

    # Save result to file TODO: remove before production deployment
    File.write("tone_result.json", JSON.pretty_generate(tone_result))

    @tone_results = {}
    tone_result["document_tone"]["tones"].each do |tone|
      @tone_results[tone['tone_name']] = (tone['score'] * 100).round(1)
    end
  end
end
