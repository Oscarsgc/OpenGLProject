require 'opengl'
require 'glu'
require 'glut'
require 'chunky_png'
require 'wavefront'
require 'sounder'

require_relative 'model'

include Gl
include Glu
include Glut

FPS = 60.freeze
DELAY_TIME = (1000.0 / FPS)
DELAY_TIME.freeze

def load_objects
  # cargar modelo y preparar arreglos necesarios
  @bg = Model.new('bg', 'bg.mtl')
  @remote = Model.new('Remote', 'Remote.mtl')
  @lightsaber = Model.new('LightSaber', 'LightSaber.mtl')
  @shooting = Model.new('ball', 'ball.mtl')
  @shooting2 = Model.new('ball', 'ball.mtl')
  @shooting3 = Model.new('ball', 'ball.mtl')
  @sound = Sounder::Sound.new "open.wav"
  @sound2 = Sounder::Sound.new "close.wav"
  @sound3 = Sounder::Sound.new "turn.wav"
  @sound4 = Sounder::Sound.new "hit.wav"

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
  ambient = [1.0, 1.0, 1.0, 1.0]


  glLightfv(GL_LIGHT0, GL_POSITION, position)
  glLightfv(GL_LIGHT0, GL_DIFFUSE, color)
  glLightfv(GL_LIGHT0, GL_SPECULAR, color)
  glLightModelfv(GL_LIGHT_MODEL_AMBIENT, ambient)
end

def draw
  @frame_start = glutGet(GLUT_ELAPSED_TIME)
  check_fps
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)

  #drawBG
  glPushMatrix
  #transformaciones del modelo
  glRotatef(90,0.0, 1.0, 0.0)
  glRotatef(180,1.0, 0.0, 0.0)
  glTranslatef(0.0, 0.0, 0.0)
  glScalef(100.0, 100.0, 100.0)
  @bg.draw
  #finalizacion
  glPopMatrix


  #drawRemote
  glPushMatrix
  #transformaciones del modelo
  #glTranslate(0.0, 40.0, 0.0)

  glRotatef(@spin, 0.0, 1.0, 0.5)
  glRotatef(@spin2,0.0, 1.0, 0.5)
  glTranslatef(@remote_x, @remote_y, @remote_z)
  glScalef(2.0, 2.0, 2.0)
  @remote.draw
  #finalizacion
  glPopMatrix


  #drawLightsaber
  glPushMatrix
  #transformaciones del modelo
  glRotatef(@lightSaber_spin, 1.0, 1.0, 0.5)
  #glRotatef(@lightSaber_spin2,0.0, -20.0, -5.5)
  glTranslatef(@lightsaber_x, @lightsaber_y, @lightsaber_z)
  glScalef(0.04, 0.04, 0.04)
  @lightsaber.draw
  #finalizacion
  glPopMatrix



  #drawShooting
  glPushMatrix
  #transformaciones del modelo
  #glTranslate(0.0, 40.0, 0.0)
  glRotatef(@spin, 0.0, 1.0, 0.5)
  glRotatef(@spin2,0.0, 1.0, 0.5)
  glTranslatef((@shooting_x.to_f - @var1.to_f)/3.0, (@shooting_y.to_f - @var2.to_f)*3.0, @shooting_z.to_f - @var3.to_f)
  glScalef(0.04, 0.04, 0.04)
  @shooting.draw
  #finalizacion
  glPopMatrix


  #drawShooting
  glPushMatrix
  #transformaciones del modelo
  #glTranslate(0.0, 40.0, 0.0)
  glRotatef(@spin, 0.0, 1.0, 0.5)
  glRotatef(@spin2,0.0, 1.0, 0.5)
  glTranslatef((@shooting_x.to_f - @var1.to_f)/4.0, (@shooting_y.to_f - @var2.to_f)*2.0, @shooting_z.to_f - @var3.to_f)
  glScalef(0.04, 0.04, 0.04)
  @shooting2.draw
  #finalizacion
  glPopMatrix

  #drawShooting
  glPushMatrix
  #transformaciones del modelo
  #glTranslate(0.0, 40.0, 0.0)
  glRotatef(@spin, 0.0, 1.0, 0.5)
  glRotatef(@spin2,0.0, 1.0, 0.5)
  glTranslatef((@shooting_x.to_f - @var1.to_f)/2.0, (@shooting_y.to_f - @var2.to_f)*4.0, @shooting_z.to_f - @var3.to_f)
  glScalef(0.04, 0.04, 0.04)
  @shooting3.draw
  #finalizacion
  glPopMatrix

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

  if @remote_helper == true
    @spin = @spin + 2.0
    @spin2 = @spin2 + 2.0
    if @spin > 60
      @remote_helper = false
    end
  else
    @spin = @spin - 2.0
    @spin2 = @spin2 - 2.0
    if @spin < 1
      @remote_helper = true
    end
  end



  if @light_saber_helper == true
    @lightSaber_spin = @lightSaber_spin + 2.0
    if @lightSaber_spin > 180
      @light_saber_helper = false
      @sound3.play
    end
  else
    @lightSaber_spin = @lightSaber_spin - 2.0
    if @lightSaber_spin < 1
      @light_saber_helper = true
      @sound3.play
    end
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
    fps = (@frame_count / (delta_time / 1000.0)) +20.0
    puts "FPS: #{fps}"
    @frame_count = 0
    @previous_time = current_time
  end
end


@spin = 0.0
@spin2 = 0.0
@lightSaber_spin = 0.0
@light_saber_helper = false

@remote_x = 25.0
@remote_y = 25.0
@remote_z = -1.0
@remote_helper = false

@shooting_x = 25.0
@shooting_y = 25.0
@shooting_z = -1.0

@lightsaber_x = 15.0
@lightsaber_y = -30.0
@lightsaber_z = 0.0

@previous_time = 0
@frame_count = 0

load_objects
glutInit
glutInitDisplayMode(GLUT_RGB | GLUT_DOUBLE | GLUT_DEPTH)
glutInitWindowSize(800, 600)
glutInitWindowPosition(10,10)
glutCreateWindow("Entrena pequeño jedi")
@sound.play
glutDisplayFunc :draw
glutReshapeFunc :reshape
glutIdleFunc :idle
initGL
glutMainLoop
