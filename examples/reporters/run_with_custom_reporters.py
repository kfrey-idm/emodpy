"""
This file demonstrates how to create experiment/simulations using custom reporters provided by the user
"""
import os
import sys
from functools import partial

from idmtools.core.platform_factory import Platform
from idmtools.entities.experiment import Experiment

from emodpy.emod_task import EMODTask
from emodpy.reporters.custom import Report_TBHIV_ByAge

current_directory = os.path.dirname(os.path.realpath(__file__))
INPUT_PATH = os.path.join(current_directory, "inputs")
EXPERIMENT_NAME = os.path.split(sys.argv[0])[1]  # expname will be file name

if __name__ == "__main__":
    # Create the platform
    with Platform('COMPS2') as platform:

        # Create EMODTask with the set of provided files
        ip = partial(os.path.join, INPUT_PATH)
        task = EMODTask.from_files(eradication_path=ip("Eradication.exe"), config_path=ip("config.json"),
                                   campaign_path=ip("campaign.json"), demographics_paths=
                                   [ip("Base_Demog_Trunk_TB.json"), ip("Base_Overlay_TB.json")])

        # Points the reporters to the correct dll path
        task.reporters.add_dll_folder(os.path.join(INPUT_PATH))

        # Create a report TBHIV by Age and add a couple of reports to it
        report = Report_TBHIV_ByAge() 
        report.configure_report(200, 0, 0, 200)
        #report.configure_report(100, 0, 0, 100)

        task.reporters.add_reporter(report)

        # Create the experiment from task and run
        experiment = Experiment.from_task(task, name=EXPERIMENT_NAME)
        experiment.run(wait_until_done=True)

        # use system status as the exit code
        sys.exit(0 if experiment.succeeded else -1)
