/*
 * Copyright (c) 2011 Jesse Freeman
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

/**
 * Created by IntelliJ IDEA.
 * User: jessefreeman
 * Date: 4/18/11
 * Time: 9:17 PM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.matchhack.views
{
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

    import flashx.textLayout.formats.TextAlign;

    public class StatusBarView extends Sprite
    {
        [Embed(source='../../../../../build/assets/fonts/nokiafc22.ttf', fontName="system", embedAsCFF=false, mimeType="application/x-font-truetype")]
        private static var EMBEDDED_FONT:String;
        private var scoreTF:TextField;
        private var levelTF:TextField;
        private var turnsTF:TextField;
        private const SCORE_LABEL:String = "Score\n";
        private const LEVEL_LABEL:String = "Level\n";
        private const TURNS_LABEL:String = "Turns\n";
        private var _message:TextField;

        public function StatusBarView()
        {
            createDisplays();
        }

        private function createDisplays():void
        {
            var textFormatLarge:TextFormat = new TextFormat("system", 16, 0xffffff);
            textFormatLarge.align = TextAlign.CENTER;

            scoreTF = addChild(createTextField(textFormatLarge, SCORE_LABEL+"999999")) as TextField;

            levelTF= addChild(createTextField(textFormatLarge, LEVEL_LABEL+"99")) as TextField;
            levelTF.x = scoreTF.x + scoreTF.width;

            turnsTF= addChild(createTextField(textFormatLarge, TURNS_LABEL+"999999")) as TextField;
            turnsTF.x = levelTF.x + levelTF.width;


            var textFormatSmall:TextFormat = new TextFormat("system", 8, 0xffffff);
            textFormatSmall.align = TextAlign.CENTER;

            _message = addChild(createTextField(textFormatSmall, "Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit.", turnsTF.x + turnsTF.width)) as TextField;
            _message.y = scoreTF.height;
            clear();
        }

        private function createTextField(textFormat:TextFormat, defaultText:String = "", width:int = 78):TextField
        {
            var textField:TextField = new TextField();
            textField.defaultTextFormat = textFormat;
            textField.text = defaultText;
            textField.embedFonts = true;
            textField.selectable = false;
            textField.autoSize = TextFieldAutoSize.LEFT;
            textField.multiline = true;
            textField.width = width;
            textField.wordWrap = true;

            return textField;
        }

        public function setScore(value:int):void
        {
            var defaultText:String = "000000";
            scoreTF.htmlText = SCORE_LABEL+defaultText.slice(0, defaultText.length - value.toString().length) + value.toString();
        }

        public function setLevel(value:int):void
        {
            var defaultText:String = "00";
            levelTF.htmlText = LEVEL_LABEL+defaultText.slice(0, defaultText.length - value.toString().length) + value.toString();
        }

        public function setTurns(value:int):void
        {
            var defaultText:String = "000000";
            turnsTF.htmlText = TURNS_LABEL+defaultText.slice(0, defaultText.length - value.toString().length) + value.toString();
        }

        public function setMessage(value:String):void
        {
            _message.text = value;
        }

        public function clear():void
        {
            scoreTF.htmlText = SCORE_LABEL+"000000";
            levelTF.htmlText = LEVEL_LABEL+"00";
            turnsTF.htmlText = TURNS_LABEL+"000000";
            _message.htmlText = "";
        }

        public function get message():TextField
        {
            return _message;
        }
    }
}
