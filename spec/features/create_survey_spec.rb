require 'spec_helper'

#from spec/support/surveyforms_helpers.rb
include SurveyFormsCreationHelpers::CreateSurvey
include SurveyFormsCreationHelpers::BuildASurvey

feature "User creates a new survey using a browser",  %q{
  As a user
  I want to create a new survey using a browser
  So that I don't have to learn the Surveyor DSL or dive into technical weeds} do

  #force a cr/lf to make the output look better
  scenario " " do
  end

  context "User has not yet started a new survey" do
    scenario "User starts a new survey" do
      #Given I'm on the surveyform web page
      visit surveyforms_path

      #When I click "New Survey"
      click_link "New Survey"

      #Then I see the "Create New Survey" page
      expect(page).to have_content("Create New Survey")
    end

    scenario "User gives the survey a title" do
      #Given I'm on the "Create New Survey" page
      visit new_surveyform_path

      #When I fill in a title
      fill_in "Title", with: "How was Boston?"

      #And I save the survey
      click_button "Save Changes"

      #Then I can start entering more details, like sections
      expect(page).to have_button "Add Section"

      #And questions
      expect(page).to have_button "Add Question"
    end
  end

  context "User started a new survey" do
    before :each do
      start_a_new_survey
    end

    scenario "User gives the section a title", :js=>true do
      #Given I've started a new survey
      #When I click the "Edit Section Title" button
      click_button "Edit Section Title"

      #Then I see a window pop-up
      expect(page).to have_css('iframe')
      within_frame 0 do

      #And I see a new form for "Edit Survey Section"
        find('form')
        expect(find('h1')).to have_content("Edit Survey Section")

      #And I enter a title
        fill_in "Title", with: "Accommodations"

      #And I save the title
        click_button "Save Changes"

      #Then the window goes away
      end

      #And I can see the correctly titled section in my survey
      expect(first_section_title).to have_content("Accommodations")
    end

    scenario "User adds a text question", :js=>true do
      #Given I've started a new survey
      #When I click the "Add Question" button
      click_button "Add Question"

      #Then I see a window pop-up
      expect(page).to have_css('iframe')
      within_frame 0 do

      #And I see a new form for "Add Question"
        find('form')
        expect(find('h1')).to have_content("Add Question")

      #And I frame the question
        fill_in "question_text", with: "Where did you stay?"

      #And I select the "text" question type
        select_question_type "Text"

      #And I save the question
        click_button "Save Changes"

      #Then the window goes away
      end

      #And I can see the question in my survey
      expect(first_question).to have_content("1) Where did you stay?")
      expect(page).to have_css("input[type='text']")
    end

    context "User adds questions of each type to the survey" do
      before :each do
        start_a_new_survey
      end
      scenario "User adds a number question", :js=>true do
        #Given I've added a new question
        add_question do

        #Then I select the "number" question type
          select_question_type "Number"

        #And I frame the question
          fill_in "question_text", with: "How many days did you stay?"

        #And I add the suffix, "Stayed"      
          fill_in "question_prefix", with: "Stayed"
          
        #And I add the suffix, "days"
          fill_in "question_suffix", with: "days at hotel"

        #And I sav the question
          click_button "Save Changes"

        #Then the window goes away
        end

        #And I can see the question in my survey
        expect(first_question).to have_content("1) How many days did you stay?")
        expect(page).to have_css("input[type='text']")
        expect(page).to have_content(/Stayed.*days at hotel/)
      end


      scenario "User adds a multiple choice question", :js=>true do
        #Given I've added a new question
        add_question do

        #Then I select the "multiple choice" question type
          select_question_type "Multiple Choice (only one answer)"

        #And I frame the question
          fill_in "question_text", with: "What type of room did you get?"

        #And I add some choices"
          fill_in "question_answers_textbox", with: """Deluxe King
                                                     Standard Queen
                                                     Standard Double"""

        #And I save the question
          click_button "Save Changes"

        #Then the window goes away
        end

        #And I can see the question in my survey
        expect(first_question).to have_content("1) What type of room did you get?")
        expect(page).to have_css("input[type='radio'][value='Deluxe King']")
        expect(page).to have_css("input[type='radio'][value='Standard Queen']")
        expect(page).to have_css("input[type='radio'][value='Standard Double']")
      end


      scenario "User adds a choose any question", :js=>true do
        #Given I've added a new question
        add_question do

        #Then I select the "multiple choice, multiple answers" question type
          select_question_type "Multiple Choice (multiple answers)"

        #And I frame the question
          fill_in "question_text", with: "What did you order from the minibar?"

        #And I add some choices"
          fill_in "question_answers_textbox", with: """Bottled Water
                                                     Kit Kats
                                                     Scotch"""

        #And I save the question
          click_button "Save Changes"

        #Then the window goes away
        end

        #And I can see the question in my survey
        expect(first_question).to have_content("1) What did you order from the minibar?")
        expect(page).to have_css("input[type='checkbox'][value='Bottled Water']")
        expect(page).to have_css("input[type='checkbox'][value='Kit Kats']")
        expect(page).to have_css("input[type='checkbox'][value='Scotch']")
      end


      scenario "User adds a dropdown list", :js=>true do
        #Given I've added a new question
        add_question do

        #Then I select the "Dropdown" question type
          select_question_type "Dropdown List"

        #And I frame the question
          fill_in "question_text", with: "1) What neighborhood were you in?"

        #And I add some choices"
          fill_in "question_answers_textbox", with: """ Financial District
                                                      Back Bay
                                                      North End"""

        #And I save the question
          click_button "Save Changes"

        #Then the window goes away
        end

        #And I can see the question in my survey
        expect(first_question).to have_content("1) What neighborhood were you in?")
        expect(page).to have_css("option[value='Financial District']")
        expect(page).to have_css("option[value='Back Bay']")
        expect(page).to have_css("option[value='North End']")
      end


      scenario "User adds a date question", :js=>true do
        #Given I've added a new question
        add_question do

        #Then I select the "Date" question type
          select_question_type "Date"

        #And I frame the question
          fill_in "question_text", with: "When did you checkout?"

        #And I save the question
          click_button "Save Changes"

        #Then the window goes away
        end

        #And I can see the question in my survey
        expect(first_question).to have_content("1) When did you checkout?")
        expect(page).to have_css("div.ui-datepicker",:visible=>false)

        #Then I click on the question
        1.times {page.execute_script "$('input.date_picker').trigger('focus')"}

        #And I see a datepicker popup
        expect(page).to have_css("div.ui-datepicker", :visible=>true)
      end

      scenario "User adds a label", :js=>true do
        #Given I've added a new question
        add_question do

        #Then I select the "Label" question type
          select_question_type "Label"

        #And I frame the question
          fill_in "question_text", with: "You don't need to answer the following questions if you are not comfortable."

        #And I save the question
          click_button "Save Changes"

        #Then the window goes away
        end

        #And I can see the label in my survey and it has no question number
        expect(page).to have_content(/(?<!1\)\s)You don't need to answer the following questions if you are not comfortable./)
      end

      scenario "User adds a text box question", :js=>true do
        #Given I've added a new question
        add_question do

        #Then I select the "Text Box" question type
          select_question_type "Text Box (for extended text, like notes, etc.)"

        #And I frame the question
          fill_in "question_text", with: "What did you think of the staff?"

        #And I save the question
          click_button "Save Changes"

        #Then the window goes away
        end

        #And I can see the question in my survey
        expect(first_question).to have_content("1) What did you think of the staff?")
        expect(page).to have_css("textarea")
      end

      scenario "User adds a slider question", :js=>true do
        #Given I've added a new question
        add_question do

        #Then I select the "Slider" question type
          select_question_type "Slider"

        #And I frame the question
          fill_in "question_text", with: "What did you think of the food?"

        #And I add some choices"
          fill_in "question_answers_textbox", with: """Sucked!
                                                     Meh
                                                     Good
                                                     Wicked good!"""       


        #And I save the question
          click_button "Save Changes"

        #Then the window goes away
        end

        #And I can see the slider in my survey
        expect(first_question).to have_content("1) What did you think of the food?")
        expect(page).to have_css(".ui-slider")

        #And I can see the text for both ends of the slider (but not the middle)
        expect(page).to have_content("Sucked!")
        expect(page).not_to have_content("Meh")
        expect(page).not_to have_content("Good")
        expect(page).to have_content("Wicked good!")
      end

      scenario "User adds a star question", :js=>true do
        #Given I've added a new question
        add_question do

        #Then I select the "Star" question type
          select_question_type "Star"

        #And I frame the question
          fill_in "question_text", with: "How would you rate your stay?"

        #And I save the question
          click_button "Save Changes"

        #Then the window goes away
        end

        #And I can see the question in my survey
        expect(first_question).to have_content("1) How would you rate your stay?")

        #And I see stars!
        expect(page).to have_css('div.star-rating a')
      end


      scenario "User includes a file upload in the survey", :js=>true do
        #Given I've added a new question
        add_question do
        #Then I select the "Star" question type
          select_question_type "File Upload"

        #And I frame the question
          fill_in "question_text", with: "Please upload a copy of your bill."

        #And I save the question
          click_button "Save Changes"

        #Then the window goes away
        end

        #And I can see the question in my survey
        expect(first_question).to have_content("1) Please upload a copy of your bill.")

        #And I can browse my files
        expect(page).to have_css("input[type='file']")
      end
      
      scenario "User adds a grid - pick one question", :js=>true do
        #Given I've added a new question
        add_question do
        
        #And I frame the question
          fill_in "question_text", with: "Rate the service:"

        #Then I select the "Star" question type
          select_question_type "Grid (pick one)"

        #And I add columns to the grid
          expect(page).to have_css("#question_grid_columns_textbox")
          fill_in "question_grid_columns_textbox", with: "Poor\nOk\nGood\nOutstanding"
          
        #And I add columns to the grid
          fill_in "question_grid_rows_textbox", with: "Front Desk\nConcierge\nRoom Service\nValet"

        #And I save the question
          click_button "Save Changes"

        #Then the window goes away
        end

        #And I can see the question in my survey
        expect(first_question).to have_content("1) Rate the service:")

        #And I see a nice grid of radio buttons
        expect(page).to have_content(/1\) Rate the service.*Poor.*Ok.*Good.*Outstanding.*(?<!\d\)\s)Front Desk.*(?<!\d\)\s)Concierge.*(?<!\d\)\s)Room Service.*(?<!\d\)\s)Valet/m)
        
        expect(page).to have_css("input[type='radio'][value='Poor']")
        expect(page).to have_css("input[type='radio'][value='Ok']")
        expect(page).to have_css("input[type='radio'][value='Good']")
        expect(page).to have_css("input[type='radio'][value='Outstanding']")
      end
    end
  end #end context "user has started a new survey"

  scenario "User saves a survey with all the different question types", :js=>true do
    build_a_survey
    click_button "Save Changes"
    expect(page).to have_content(/[Ss]uccessfully update/)
    expect(page).to have_content("How was Boston?")
  end
end #end feature
