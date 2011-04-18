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
 * Date: 3/17/11
 * Time: 8:54 PM
 * To change this template use File | Settings | File Templates.
 */
package com.gamecook.matchhack.managers
{
    import com.google.analytics.GATracker;
    import com.jessefreeman.factivity.activities.BaseActivity;
    import com.jessefreeman.factivity.managers.ActivityManager;

    import flash.display.DisplayObjectContainer;
    import flash.system.Capabilities;

    public class MHActivityManager extends ActivityManager
    {

        private var tracker:GATracker;
        private var os:String;
        private var activeClassName:String;


        public function MHActivityManager(tracker:GATracker)
        {
            this.tracker = tracker;
            os = Capabilities.version.substr(0, 3);
        }

        override public function set target(target:DisplayObjectContainer):void
        {

            super.target = target;
        }

        override public function setCurrentActivity(activity:Class, data:* = null):void
        {
            activeClassName = String(activity).split(" ")[1].substr(0, -1);
            tracker.trackPageview("/MatchHack/" + os + "/" + activeClassName);
            super.setCurrentActivity(activity, data);
        }

        override protected function addActivity(newActivity:BaseActivity):void
        {
            //Inject tracker to any new Activity
            if (newActivity.hasOwnProperty("tracker"))
                newActivity["tracker"] = tracker;

            super.addActivity(newActivity);
        }

    }
}
