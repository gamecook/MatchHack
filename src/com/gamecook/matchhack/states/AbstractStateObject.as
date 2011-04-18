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
 * Date: 3/18/11
 * Time: 3:46 PM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.matchhack.states
{
    import flash.net.SharedObject;

    public class AbstractStateObject implements IStateObject
    {
        protected var sharedObject:SharedObject;
        protected var _dataObject:Object;
        protected var id:String;

        public function AbstractStateObject(self:AbstractStateObject, id:String)
        {
            this.id = id;
            if (!(self is AbstractStateObject))
                throw Error("This is an Abstract Class.");
        }

        public function load():void
        {
            try {
                sharedObject = SharedObject.getLocal(id);
                _dataObject = sharedObject.data;
            }
            catch(error:Error) {
                trace("Could not load shared obj");
            }
        }

        public function save():String
        {
            //TODO need to add some logic to make sure this actually saves
            var success:String = sharedObject.flush();
            trace("StateObject", id, "Size:", (sharedObject.size / 1,024), "k");

            return success;
        }

        public function clear():void
        {
            sharedObject.clear();
            _dataObject = sharedObject.data;
        }

        public function get dataObject():Object
        {
            return _dataObject;
        }
    }
}
