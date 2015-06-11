require 'opengl'
require 'glu'
require 'glut'
require 'chunky_png'
require 'wavefront'

require_relative 'model'

include Gl
include Glu
include Glut

FPS = 60.freeze
DELAY_TIME = (1000.0 / FPS)
DELAY_TIME.freeze

def load_objects
  # cargar modelo y preparar arreglos necesarios
  puts "Loading model"
  @remote = Model.new('Remote', 'Remote.mtl')
 # @lightsaber = Model.new('RedLightsaber', 'RedLightsaber.mtl')

  puts "model loaded"
end

def initGL
  glEnable(GL_DEPTH_TEST)
  glClearColor(0.0, 0.0, 0.0, 0.0)
  glEnable(GL_LIGHTING)
  glEnable(GL_LIGHT0)
  glEnable(GL_COLOR_MATERIAL)
  glColorMaterial(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE)
  glEnable(GL_NORMALIZE)
  glShadeModel(GL_SMOOTH)
  glEnable(GL_CULL_FACE)
  glCullFace(GL_BACK)

  position = [0.0, 50.0, 0.0]
  color = [1.0, 1.0, 1.0, 1.0]
  ambient = [0.2, 0.2, 0.2, 1.0]


  glLightfv(GL_LIGHT0, GL_POSITION, position)
  glLightfv(GL_LIGHT0, GL_DIFFUSE, color)
  glLightfv(GL_LIGHT0, GL_SPECULAR, color)
  glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambient)
end

def draw
  @frame_start = glutGet(GLUT_ELAPSED_TIME)
  check_fps
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)

  #drawRemote
  glPushMatrix
  #transformaciones del modelo
  #glTranslate(0.0, 40.0, 0.0)
  glRotatef(@spin, 0.0, 1.0, 0.5)
  glRotatef(@spin2,0.0, 1.0, 0.5)
  glTranslatef(25.0,40.0,0.0)
  glScalef(2.0, 2.0, 2.0)
  @remote.draw
  #finalizacion
  glPopMatrix

=begin
  #drawLightsaber
  glPushMatrix
  #transformaciones del modelo
  glRotatef(@spin, -1.0, 0.0, 0.0)
  glRotatef(@spin2,0.0, -10.0, -5.5)
  glTranslatef(15.0,10.0,0.0)
  glScalef(2.0, 2.0, 2.0)
  @lightsaber.draw
  #finalizacion
  glPopMatrix
=end

  glutSwapBuffers
end

def reshape(width, height)
  #glutPostRedisplay
  glViewport(0, 0, width, height)
  glMatrixMode(GL_PROJECTION)
  glLoadIdentity
  #glOrtho(0.0, 1.0, 0.0, 1.0, -1.0, 1.0)
  gluPerspective(45, (1.0 * width) / height, 0.001, 1000.0)
  #gluPerspective(45, (1.0 * width) / height, 0.005, 500.0)
  glMatrixMode(GL_MODELVIEW)
  glLoadIdentity()
  gluLookAt(0.0, 50.0, -125.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0)
end

def idle
  @spin = @spin + 1.0
  @spin2 = @spin2 + 1.0
  if @spin > 360.0
    @spin = @spin - 360.0
    @spin2 = @spin2 + 360.0
  end

  @frame_time = glutGet(GLUT_ELAPSED_TIME) - @frame_start
  
  if (@frame_time< DELAY_TIME)
    sleep((DELAY_TIME - @frame_time) / 1000.0)
  end
  glutPostRedisplay
end



def check_fps
  current_time = glutGet(GLUT_ELAPSED_TIME)
  delta_time = current_time - @previous_time

  @frame_count += 1

  if (delta_time > 1000)
    fps = @frame_count / (delta_time / 1000.0)
    puts "FPS: #{fps}"
    @frame_count = 0
    @previous_time = current_time
  end
end



@spin = 0.0
@previous_time = 0
@frame_count = 0
@spin2 = 0.0
load_objects
glutInit
glutInitDisplayMode(GLUT_RGB | GLUT_DOUBLE | GLUT_DEPTH)
glutInitWindowSize(800,600)
glutInitWindowPosition(10,10)
glutCreateWindow("Hola OpenGL, en Ruby")
glutDisplayFunc :draw
glutReshapeFunc :reshape
glutIdleFunc :idle
initGL
glutMainLoop