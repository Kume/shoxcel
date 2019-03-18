require 'jar_dependencies'
JBUNDLER_LOCAL_REPO = Jars.home
JBUNDLER_JRUBY_CLASSPATH = []
JBUNDLER_JRUBY_CLASSPATH.freeze
JBUNDLER_TEST_CLASSPATH = []
JBUNDLER_TEST_CLASSPATH.freeze
JBUNDLER_CLASSPATH = []
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/org/apache/xmlbeans/xmlbeans/2.6.0/xmlbeans-2.6.0.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/org/yaml/snakeyaml/1.18/snakeyaml-1.18.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/org/apache/poi/poi-ooxml/3.17/poi-ooxml-3.17.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/org/apache/poi/poi-ooxml-schemas/3.17/poi-ooxml-schemas-3.17.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/org/apache/poi/poi/3.17/poi-3.17.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/jline/jline/2.11/jline-2.11.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/org/apache/commons/commons-collections4/4.1/commons-collections4-4.1.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/commons-codec/commons-codec/1.10/commons-codec-1.10.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/stax/stax-api/1.0.1/stax-api-1.0.1.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/com/github/virtuald/curvesapi/1.04/curvesapi-1.04.jar')
JBUNDLER_CLASSPATH.freeze
