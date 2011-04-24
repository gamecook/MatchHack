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
 * User: jfreeman
 * Date: 4/19/11
 * Time: 11:33 AM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.matchhack.factories
{
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

    public class TextFieldFactory
    {
        public static const SCORE_LABEL:String = "SCORE\n";
        public static const LEVEL_LABEL:String = "LEVEL\n";
        public static const TURNS_LABEL:String = "TURNS\n";
        private static const DEFAULT_SCORE_PADDING:String = "000000";
        private static const DEFAULT_LEVEL_PADDING:String = "00";

        public static const textFormatLarge:TextFormat = new TextFormat("system", 16, 0xffffff, null, null, null, null, null, "center");
        public static const textFormatSmall:TextFormat = new TextFormat("system", 8, 0xffffff, null, null, null, null, null, "left");

        public static function createTextField(textFormat:TextFormat, defaultText:String = "", width:int = 78):TextField
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

        public static function padScore(value:String = ""):String
        {
            return pad(DEFAULT_SCORE_PADDING, value);
        }

        public static function padLevel(value:String = ""):String
        {
            return pad(DEFAULT_LEVEL_PADDING, value);
        }

        public static function pad(padding:String, value:String):String
        {
            return padding.slice(0, padding.length - value.toString().length) + value.toString()
        }
    }
}
