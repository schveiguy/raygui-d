module controls_test_suite;
@nogc nothrow:
extern(C): __gshared:
/*******************************************************************************************
*
*   raygui - controls test suite
*
*   TEST CONTROLS:
*       - GuiDropdownBox()
*       - GuiCheckBox()
*       - GuiSpinner()
*       - GuiValueBox()
*       - GuiTextBox()
*       - GuiButton()
*       - GuiComboBox()
*       - GuiListView()
*       - GuiToggleGroup()
*       - GuiTextBoxMulti()
*       - GuiColorPicker()
*       - GuiSlider()
*       - GuiSliderBar()
*       - GuiProgressBar()
*       - GuiColorBarAlpha()
*       - GuiScrollPanel()
*
*
*   DEPENDENCIES:
*       raylib 4.0 - Windowing/input management and drawing.
*       raygui 3.2 - Immediate-mode GUI controls.
*
*   COMPILATION (Windows - MinGW):
*       gcc -o $(NAME_PART).exe $(FILE_NAME) -I../../src -lraylib -lopengl32 -lgdi32 -std=c99
*
*   LICENSE: zlib/libpng
*
*   Copyright (c) 2016-2022 Ramon Santamaria (@raysan5)
*
**********************************************************************************************/

import raylib;

import raygui;
import styles.cyber;             // raygui style: cyber
import styles.jungle;            // raygui style: jungle
import styles.lavanda;           // raygui style: lavanda
import styles.dark;              // raygui style: dark
import styles.bluish;            // raygui style: bluish
import styles.terminal;          // raygui style: terminal


public import core.stdc.string;             // Required for: strcpy()

//------------------------------------------------------------------------------------
// Program main entry point
//------------------------------------------------------------------------------------
int main() {
    // Initialization
    //---------------------------------------------------------------------------------------
    const(int) screenWidth = 960;
    const(int) screenHeight = 560;

    InitWindow(screenWidth, screenHeight, "raygui - controls test suite");
    SetExitKey(0);

    // GUI controls initialization
    //----------------------------------------------------------------------------------
    int dropdownBox000Active = 0;
    bool dropDown000EditMode = false;

    int dropdownBox001Active = 0;
    bool dropDown001EditMode = false;

    int spinner001Value = 0;
    bool spinnerEditMode = false;

    int valueBox002Value = 0;
    bool valueBoxEditMode = false;

    char[64] textBoxText = "Text box";
    bool textBoxEditMode = false;

    char[1024] textBoxMultiText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
    bool textBoxMultiEditMode = false;

    int listViewScrollIndex = 0;
    int listViewActive = -1;

    int listViewExScrollIndex = 0;
    int listViewExActive = 2;
    int listViewExFocus = -1;
    const(char)*[8] listViewExList = [ "This", "is", "a", "list view", "with", "disable", "elements", "amazing!" ];

    char[256] multiTextBoxText = "Multi text box";
    bool multiTextBoxEditMode = false;
    Color colorPickerValue = Colors.RED;

    float sliderValue = 50.0f;
    float sliderBarValue = 60;
    float progressValue = 0.1f;

    bool forceSquaredChecked = false;

    float alphaValue = 0.5f;

    //int comboBoxActive = 1;
    int visualStyleActive = 0;
    int prevVisualStyleActive = 0;

    int toggleGroupActive = 0;
    int toggleSliderActive = 0;

    Vector2 viewScroll = { 0, 0 };
    //----------------------------------------------------------------------------------

    // Custom GUI font loading
    //Font font = LoadFontEx("fonts/rainyhearts16.ttf", 12, 0, 0);
    //GuiSetFont(font);

    bool exitWindow = false;
    bool showMessageBox = false;

    char[256] textInput = 0;
    char[256] textInputFileName = 0;
    bool showTextInputBox = false;

    float alpha = 1.0f;

    // DEBUG: Testing how those two properties affect all controls!
    //GuiSetStyle(DEFAULT, TEXT_PADDING, 0);
    //GuiSetStyle(DEFAULT, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER);

    SetTargetFPS(60);
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!exitWindow)    // Detect window close button or ESC key
    {
        // Update
        //----------------------------------------------------------------------------------
        exitWindow = WindowShouldClose();

        if (IsKeyPressed(KeyboardKey.KEY_ESCAPE)) showMessageBox = !showMessageBox;

        if (IsKeyDown(KeyboardKey.KEY_LEFT_CONTROL) && IsKeyPressed(KeyboardKey.KEY_S)) showTextInputBox = true;

        if (IsFileDropped())
        {
            FilePathList droppedFiles = LoadDroppedFiles();

            if ((droppedFiles.count > 0) && IsFileExtension(droppedFiles.paths[0], ".rgs")) GuiLoadStyle(droppedFiles.paths[0]);

            UnloadDroppedFiles(droppedFiles);    // Clear internal buffers
        }

        //alpha -= 0.002f;
        if (alpha < 0.0f) alpha = 0.0f;
        if (IsKeyPressed(KeyboardKey.KEY_SPACE)) alpha = 1.0f;

        GuiSetAlpha(alpha);

        //progressValue += 0.002f;
        if (IsKeyPressed(KeyboardKey.KEY_LEFT)) progressValue -= 0.1f;
        else if (IsKeyPressed(KeyboardKey.KEY_RIGHT)) progressValue += 0.1f;
        if (progressValue > 1.0f) progressValue = 1.0f;
        else if (progressValue < 0.0f) progressValue = 0.0f;

        if (visualStyleActive != prevVisualStyleActive)
        {
            GuiLoadStyleDefault();

            switch (visualStyleActive)
            {
                case 0: break;      // Default style
                case 1: GuiLoadStyleJungle(); break;
                case 2: GuiLoadStyleLavanda(); break;
                case 3: GuiLoadStyleDark(); break;
                case 4: GuiLoadStyleBluish(); break;
                case 5: GuiLoadStyleCyber(); break;
                case 6: GuiLoadStyleTerminal(); break;
                default: break;
            }

            GuiSetStyle(LABEL, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT);

            prevVisualStyleActive = visualStyleActive;
        }
        //----------------------------------------------------------------------------------

        // Draw
        //----------------------------------------------------------------------------------
        BeginDrawing();

            ClearBackground(GetColor(GuiGetStyle(DEFAULT, BACKGROUND_COLOR)));

            // raygui: controls drawing
            //----------------------------------------------------------------------------------
            // Check all possible events that require GuiLock
            if (dropDown000EditMode || dropDown001EditMode) GuiLock();

            // First GUI column
            //GuiSetStyle(CHECKBOX, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT);
            GuiCheckBox(Rectangle( 25, 108, 15, 15 ), "FORCE CHECK!", &forceSquaredChecked);

            GuiSetStyle(TEXTBOX, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER);
            //GuiSetStyle(VALUEBOX, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT);
            if (GuiSpinner(Rectangle( 25, 135, 125, 30 ), null, &spinner001Value, 0, 100, spinnerEditMode)) spinnerEditMode = !spinnerEditMode;
            if (GuiValueBox(Rectangle( 25, 175, 125, 30 ), null, &valueBox002Value, 0, 100, valueBoxEditMode)) valueBoxEditMode = !valueBoxEditMode;
            GuiSetStyle(TEXTBOX, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT);
            if (GuiTextBox(Rectangle( 25, 215, 125, 30 ), textBoxText.ptr, 64, textBoxEditMode)) textBoxEditMode = !textBoxEditMode;

            GuiSetStyle(BUTTON, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER);

            if (GuiButton(Rectangle( 25, 255, 125, 30 ), GuiIconText(ICON_FILE_SAVE, "Save File"))) showTextInputBox = true;

            GuiGroupBox(Rectangle( 25, 310, 125, 150 ), "STATES");
            //GuiLock();
            GuiSetState(STATE_NORMAL); if (GuiButton(Rectangle( 30, 320, 115, 30 ), "NORMAL")) { }
            GuiSetState(STATE_FOCUSED); if (GuiButton(Rectangle( 30, 355, 115, 30 ), "FOCUSED")) { }
            GuiSetState(STATE_PRESSED); if (GuiButton(Rectangle( 30, 390, 115, 30 ), "#15#PRESSED")) { }
            GuiSetState(STATE_DISABLED); if (GuiButton(Rectangle( 30, 425, 115, 30 ), "DISABLED")) { }
            GuiSetState(STATE_NORMAL);
            //GuiUnlock();

            GuiComboBox(Rectangle( 25, 480, 125, 30 ), "default;Jungle;Lavanda;Dark;Bluish;Cyber;Terminal", &visualStyleActive);

            // NOTE: GuiDropdownBox must draw after any other control that can be covered on unfolding
            GuiUnlock();
            GuiSetStyle(DROPDOWNBOX, TEXT_PADDING, 4);
            GuiSetStyle(DROPDOWNBOX, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT);
            if (GuiDropdownBox(Rectangle( 25, 65, 125, 30 ), "#01#ONE;#02#TWO;#03#THREE;#04#FOUR", &dropdownBox001Active, dropDown001EditMode)) dropDown001EditMode = !dropDown001EditMode;
            GuiSetStyle(DROPDOWNBOX, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER);
            GuiSetStyle(DROPDOWNBOX, TEXT_PADDING, 0);

            if (GuiDropdownBox(Rectangle( 25, 25, 125, 30 ), "ONE;TWO;THREE", &dropdownBox000Active, dropDown000EditMode)) dropDown000EditMode = !dropDown000EditMode;

            // Second GUI column
            GuiListView(Rectangle( 165, 25, 140, 124 ), "Charmander;Bulbasaur;#18#Squirtel;Pikachu;Eevee;Pidgey", &listViewScrollIndex, &listViewActive);
            GuiListViewEx(Rectangle( 165, 162, 140, 184 ), listViewExList.ptr, 8, &listViewExScrollIndex, &listViewExActive, &listViewExFocus);

            //GuiToggle((Rectangle){ 165, 400, 140, 25 }, "#1#ONE", &toggleGroupActive);
            GuiToggleGroup(Rectangle( 165, 360, 140, 24 ), "#1#ONE\n#3#TWO\n#8#THREE\n#23#", &toggleGroupActive);
            //GuiDisable();
            GuiSetStyle(SLIDER, SLIDER_PADDING, 2);
            GuiToggleSlider(Rectangle( 165, 480, 140, 30 ), "ON;OFF", &toggleSliderActive);
            GuiSetStyle(SLIDER, SLIDER_PADDING, 0);

            // Third GUI column
            GuiPanel(Rectangle( 320, 25, 225, 140 ), "Panel Info");
            GuiColorPicker(Rectangle( 320, 185, 196, 192 ), null, &colorPickerValue);

            //GuiDisable();
            GuiSlider(Rectangle( 355, 400, 165, 20 ), "TEST", TextFormat("%2.2f", sliderValue), &sliderValue, -50, 100);
            GuiSliderBar(Rectangle( 320, 430, 200, 20 ), null, TextFormat("%i", cast(int)sliderBarValue), &sliderBarValue, 0, 100);
            
            GuiProgressBar(Rectangle( 320, 460, 200, 20 ), null, TextFormat("%i%%", cast(int)(progressValue*100)), &progressValue, 0.0f, 1.0f);
            GuiEnable();

            // NOTE: View rectangle could be used to perform some scissor test
            Rectangle view = { 0 };
            GuiScrollPanel(Rectangle( 560, 25, 102, 354 ), null, Rectangle( 560, 25, 300, 1200 ), &viewScroll, &view);

            Vector2 mouseCell = { 0 };
            GuiGrid(Rectangle ( 560, 25 + 180 + 195, 100, 120 ), null, 20, 3, &mouseCell);

            GuiColorBarAlpha(Rectangle( 320, 490, 200, 30 ), null, &alphaValue);

            GuiSetStyle(DEFAULT, TEXT_ALIGNMENT_VERTICAL, TEXT_ALIGN_TOP);   // WARNING: Word-wrap does not work as expected in case of no-top alignment
            GuiSetStyle(DEFAULT, TEXT_WRAP_MODE, TEXT_WRAP_WORD);            // WARNING: If wrap mode enabled, text editing is not supported
            if (GuiTextBox(Rectangle( 678, 25, 258, 492 ), textBoxMultiText.ptr, 1024, textBoxMultiEditMode)) textBoxMultiEditMode = !textBoxMultiEditMode;
            GuiSetStyle(DEFAULT, TEXT_WRAP_MODE, TEXT_WRAP_NONE);
            GuiSetStyle(DEFAULT, TEXT_ALIGNMENT_VERTICAL, TEXT_ALIGN_MIDDLE);

            GuiSetStyle(DEFAULT, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT);
            GuiStatusBar(Rectangle( 0, cast(float)GetScreenHeight() - 20, cast(float)GetScreenWidth(), 20 ), "This is a status bar");
            GuiSetStyle(DEFAULT, TEXT_ALIGNMENT, TEXT_ALIGN_CENTER);
            //GuiSetStyle(STATUSBAR, TEXT_INDENTATION, 20);

            if (showMessageBox)
            {
                DrawRectangle(0, 0, GetScreenWidth(), GetScreenHeight(), Fade(Colors.RAYWHITE, 0.8f));
                int result = GuiMessageBox(Rectangle( cast(float)GetScreenWidth()/2 - 125, cast(float)GetScreenHeight()/2 - 50, 250, 100 ), GuiIconText(ICON_EXIT, "Close Window"), "Do you really want to exit?", "Yes;No");

                if ((result == 0) || (result == 2)) showMessageBox = false;
                else if (result == 1) exitWindow = true;
            }

            if (showTextInputBox)
            {
                DrawRectangle(0, 0, GetScreenWidth(), GetScreenHeight(), Fade(Colors.RAYWHITE, 0.8f));
                int result = GuiTextInputBox(Rectangle( cast(float)GetScreenWidth()/2 - 120, cast(float)GetScreenHeight()/2 - 60, 240, 140 ), GuiIconText(ICON_FILE_SAVE, "Save file as..."), "Introduce output file name:", "Ok;Cancel", textInput.ptr, 255, null);

                if (result == 1)
                {
                    // TODO: Validate textInput value and save

                    TextCopy(textInputFileName.ptr, textInput.ptr);
                }

                if ((result == 0) || (result == 1) || (result == 2))
                {
                    showTextInputBox = false;
                    TextCopy(textInput.ptr, "\0");
                }
            }
            //----------------------------------------------------------------------------------

        EndDrawing();
        //----------------------------------------------------------------------------------
    }

    // De-Initialization
    //--------------------------------------------------------------------------------------
    CloseWindow();        // Close window and OpenGL context
    //--------------------------------------------------------------------------------------

    return 0;
}
