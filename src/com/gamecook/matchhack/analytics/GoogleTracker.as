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
 * Date: 4/24/11
 * Time: 10:30 AM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.matchhack.analytics
{
    import com.google.analytics.GATracker;
    import com.google.analytics.debug.DebugConfiguration;
    import com.google.analytics.v4.Configuration;
    import com.jessefreeman.factivity.analytics.ITrack;

    import flash.display.DisplayObject;

    public class GoogleTracker extends GATracker implements ITrack
    {

        public function GoogleTracker(a:DisplayObject, a2:String, a3:String = "AS3", a4:Boolean = false, a5:Configuration = null, a6:DebugConfiguration = null)
        {
            super(a, a2, a3, a4, a5, a6);
        }

        override public function trackPageview(a:String = ""):void
        {
            super.trackPageview(a);
        }

        public function track(type:String, ... arguments)
        {
        }
    }
}
