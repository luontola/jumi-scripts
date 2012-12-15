// Copyright © 2011-2012, Esko Luontola <www.orfjackal.net>
// This software is released under the Apache License 2.0.
// The license text is at http://www.apache.org/licenses/LICENSE-2.0

package com.example;

import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class FooTest {

    @Test
    public void foo() {
        assertEquals(3, Foo.increment(2));
    }
}
