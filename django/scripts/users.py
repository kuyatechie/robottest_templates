import sys
import os

try:
    from django.contrib.auth.models import User
except:
    sys.exit(os.EX_SOFTWARE)

try:
    User.objects.create_superuser(os.environ.get('TEST_USER'),
                                  'test_user@localhost',
                                  os.environ.get('TEST_PASSWORD'))
except:
    sys.exit(os.EX_SOFTWARE)

sys.exit(0)